import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/utils/array_utils.dart';
import 'package:collection/collection.dart';

/// Constructs an atomic transaction group which may contain a combination of
/// Transactions and ABI Method calls.
class AtomicTransactionComposer {
  static const MAX_GROUP_SIZE = 16;

  static final ABI_RET_HASH = Uint8List.fromList([0x15, 0x1f, 0x7c, 0x75]);

  AtcStatus _status;
  final Map<int, AbiMethod> methodMap;
  final List<TransactionWithSigner> transactions;
  final List<SignedTransaction> signedTxns;

  AtomicTransactionComposer({
    Map<int, AbiMethod>? methods,
    List<TransactionWithSigner>? transactions,
    List<SignedTransaction>? signedTxns,
  })  : _status = AtcStatus.BUILDING,
        methodMap = methods ?? {},
        transactions = transactions ?? [],
        signedTxns = signedTxns ?? [];

  /// Get the number of transactions currently in this atomic group.
  int get count => transactions.length;

  /// Get the current status of the Atomic Transaction Composer.
  AtcStatus get status => _status;

  /// Add a transaction to this atomic group.
  ///
  /// An error will be thrown if the composer's status is not BUILDING, or if
  /// adding this transaction causes the current group to exceed MAX_GROUP_SIZE.
  void addTransaction(TransactionWithSigner signer) {
    if (signer.transaction.group != null) {
      throw ArgumentError(
          'Atomic Transaction Composer group field must be zero');
    }
    if (status != AtcStatus.BUILDING) {
      throw ArgumentError(
          'Atomic Transaction Composer only add transaction in BUILDING stage');
    }

    if (transactions.length >= MAX_GROUP_SIZE) {
      throw ArgumentError(
          'Atomic Transaction Composer cannot exceed MAX_GROUP_SIZE == 16 transactions');
    }

    transactions.add(signer);
  }

  /// Add a smart contract method call to this atomic group.
  ///
  /// An error will be thrown if the composer's status is not BUILDING, if
  /// adding this transaction causes the current group to exceed MAX_GROUP_SIZE,
  /// or if the provided arguments are invalid for the given method.
  ///
  /// For help creating a MethodCallParams object, see {@link com.algorand.algosdk.builder.transaction.MethodCallTransactionBuilder}
  Future<void> addMethodCall(MethodCallParams methodCall) async {
    if (status != AtcStatus.BUILDING) {
      throw ArgumentError(
          'Atomic Transaction Composer must be in BUILDING stage');
    }

    final txns = await methodCall.createTransactions();
    if (transactions.length + txns.length > MAX_GROUP_SIZE) {
      throw ArgumentError(
          'Atomic Transaction Composer cannot exceed $MAX_GROUP_SIZE transactions');
    }

    transactions.addAll(txns);
    methodMap[transactions.length - 1] = methodCall.method;
  }

  /// Finalize the transaction group and returned the finalized transactions.
  ///
  /// The composer's status will be at least BUILT after executing this method.
  List<TransactionWithSigner> buildGroup() {
    final compareTo = status.index - AtcStatus.BUILT.index;
    if (compareTo >= 0) {
      return transactions;
    }

    if (transactions.isEmpty) {
      throw ArgumentError(
          'should not build transaction group with 0 transaction in composer');
    }

    if (transactions.length > 1) {
      final groupTxns = transactions.map((t) => t.transaction).toList();
      final groupId = AtomicTransfer.computeGroupId(groupTxns);
      for (var tws in transactions) {
        tws.transaction.group = groupId;
      }
    }

    _status = AtcStatus.BUILT;
    return transactions;
  }

  /// Obtain signatures for each transaction in this group.
  /// If signatures have already been obtained,
  /// this method will return cached versions of the signatures.
  /// <p>
  /// The composer's status will be at least SIGNED after executing this method.
  /// <p>
  /// An error will be thrown if signing any of the transactions fails.
  ///
  /// @return an array of signed transactions.
  Future<List<SignedTransaction>> gatherSignatures() async {
    final compareTo = status.index - AtcStatus.SIGNED.index;
    if (compareTo >= 0) {
      return signedTxns;
    }

    final transactions = buildGroup();
    final txnSignerToIndices = <TxnSigner, List<int>>{};
    final tempSignedTxns =
        List<SignedTransaction?>.filled(transactions.length, null);
    for (var i = 0; i < transactions.length; i++) {
      final tws = transactions[i];
      if (!txnSignerToIndices.containsKey(tws.signer)) {
        txnSignerToIndices[tws.signer] = <int>[];
      }
      txnSignerToIndices[tws.signer]?.add(i);
    }

    final txnGroup = List<RawTransaction?>.filled(transactions.length, null);
    for (var i = 0; i < transactions.length; i++) {
      txnGroup[i] = transactions[i].transaction;
    }

    for (var txnSigner in txnSignerToIndices.keys) {
      final indices = txnSignerToIndices[txnSigner];
      if (indices != null) {
        final signed = await txnSigner.signTransactions(
          txnGroup.whereNotNull().toList(),
          indices,
        );

        for (var i = 0; i < indices.length; i++) {
          tempSignedTxns[indices[i]] = signed[i];
        }
      }
    }

    if (tempSignedTxns.contains(null)) {
      throw ArgumentError('Some signer did not sign the transaction');
    }

    signedTxns.clear();
    signedTxns.addAll(tempSignedTxns.whereNotNull().toList());
    _status = AtcStatus.SIGNED;
    return signedTxns;
  }

  /// Send the transaction group to the network, but don't wait for it to be
  /// committed to a block. An error will be thrown if submission fails.
  ///
  /// The composer's status must be SUBMITTED or lower before calling this
  /// method. If submission is successful, this composer's status will update
  /// to SUBMITTED.
  ///
  /// Note: a group can only be submitted again if it fails.
  ///
  /// @return If the submission is successful, resolves to a list of TxIDs of
  /// the submitted transactions.
  Future<List<String>> submit(
    Algorand algorand, {
    bool waitForConfirmation = false,
  }) async {
    final compareTo = status.index - AtcStatus.SUBMITTED.index;
    if (compareTo > 0) {
      throw ArgumentError(
          'Atomic Transaction Composer cannot submit commited transaction.');
    }

    // Gather the signatures
    final signedTxns = await gatherSignatures();

    await algorand.sendTransactions(
      signedTxns,
      waitForConfirmation: waitForConfirmation,
    );

    _status = AtcStatus.SUBMITTED;
    return getTransactionIds();
  }

  /// Send the transaction group to the network and wait until it's committed to a block.
  /// An error will be thrown if submission or execution fails.
  ///
  /// The composer's status must be SUBMITTED or lower before calling this method, since execution is
  /// only allowed once. If submission is successful, this composer's status will update to SUBMITTED.
  /// If the execution is also successful, this composer's status will update to COMMITTED.
  ///
  /// Note: a group can only be submitted again if it fails.
  ///
  /// @return If the execution is successful, resolves to an object containing the confirmed round for
  /// this transaction, the txIDs of the submitted transactions, an array of results containing
  /// one element for each method call transaction in this group, and the raw transaction response from algod.
  /// If a method has no return value (void), then the method results array will contain null for that return value.
  Future<ExecuteResult> execute(Algorand algorand, {int waitRounds = 5}) async {
    if (_status == AtcStatus.COMMITED) {
      throw ArgumentError('Status shows this is already commited');
    }

    if (waitRounds < 0) {
      throw ArgumentError('wait round for execute should be non-negative.');
    }

    // Submit the transactions
    await submit(algorand, waitForConfirmation: false);

    var indexToWait = 0;
    for (var i = 0; i < signedTxns.length; i++) {
      if (methodMap.containsKey(i)) {
        indexToWait = i;
        break;
      }
    }

    final txInfo = await algorand.waitForConfirmation(
      signedTxns[indexToWait].transactionId,
      timeout: waitRounds,
    );

    final retList = <ReturnValue>[];
    _status = AtcStatus.COMMITED;

    for (var i = 0; i < transactions.length; i++) {
      if (!methodMap.containsKey(i)) continue;
      var currentTxInfo = txInfo;
      final txId = signedTxns[i].transactionId;

      if (i != indexToWait) {
        try {
          final response = await algorand.getPendingTransactionById(txId);
          currentTxInfo = response;
        } on AlgorandException catch (ex) {
          retList.add(ReturnValue(
            transactionId: txId,
            rawValue: null,
            value: null,
            method: methodMap[i],
            parseError: ex,
            txInfo: null,
          ));

          continue;
        }
      }

      if (methodMap[i]?.returns.type == Returns.VoidRetType) {
        retList.add(ReturnValue(
          transactionId: currentTxInfo.transaction.transactionId,
          rawValue: null,
          value: null,
          method: methodMap[i],
          parseError: null,
          txInfo: currentTxInfo,
        ));

        continue;
      }

      if (currentTxInfo.logs.isEmpty) {
        throw ArgumentError('App call transaction did not log a return value');
      }

      final retLine =
          base64Decode(currentTxInfo.logs[currentTxInfo.logs.length - 1]);
      if (!_checkLogRet(retLine)) {
        throw ArgumentError('App call transaction did not log a return value');
      }

      final abiEncoded =
          Array.copyOfRange(retLine, ABI_RET_HASH.length, retLine.length);

      Object? decoded;
      Object? parseError;
      try {
        final methodRetType = methodMap[i]?.returns.parsedType;
        decoded = methodRetType?.decode(Uint8List.fromList(abiEncoded));
      } catch (ex) {
        parseError = ex;
      }

      retList.add(ReturnValue(
        transactionId: currentTxInfo.transaction.transactionId,
        rawValue: Uint8List.fromList(abiEncoded),
        value: decoded,
        method: methodMap[i],
        parseError: parseError,
        txInfo: currentTxInfo,
      ));
    }

    return ExecuteResult(
      confirmedRound: BigInt.from(txInfo.confirmedRound ?? 0),
      transactionIds: getTransactionIds(),
      methodResults: retList,
    );
  }

  /// Get a list of all transaction ids.
  List<String> getTransactionIds() {
    return signedTxns.map((tx) => tx.transactionId).toList();
  }

  static bool _checkLogRet(Uint8List logLine) {
    if (logLine.length < ABI_RET_HASH.length) return false;
    for (var i = 0; i < ABI_RET_HASH.length; i++) {
      if (logLine[i] != ABI_RET_HASH[i]) return false;
    }
    return true;
  }
}
