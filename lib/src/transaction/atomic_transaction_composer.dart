import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/abi/abi_method.dart';
import 'package:algorand_dart/src/transaction/atc_status.dart';
import 'package:algorand_dart/src/transaction/method_call_params.dart';
import 'package:algorand_dart/src/transaction/transaction_with_signer.dart';

/// Constructs an atomic transaction group which may contain a combination of
/// Transactions and ABI Method calls.
class AtomicTransactionComposer {
  static const MAX_GROUP_SIZE = 16;

  final ATCStatus status;
  final Map<int, AbiMethod> methodMap;
  final List<TransactionWithSigner> transactions;
  final List<SignedTransaction> signedTxns;

  AtomicTransactionComposer({
    this.status = ATCStatus.BUILDING,
    Map<int, AbiMethod>? methods,
    List<TransactionWithSigner>? transactions,
    List<SignedTransaction>? signedTxns,
  })  : methodMap = methods ?? {},
        transactions = transactions ?? [],
        signedTxns = signedTxns ?? [];

  /// Get the number of transactions currently in this atomic group.
  int get count => transactions.length;

  /// Add a transaction to this atomic group.
  ///
  /// An error will be thrown if the composer's status is not BUILDING, or if
  /// adding this transaction causes the current group to exceed MAX_GROUP_SIZE.
  void addTransaction(TransactionWithSigner signer) {
    if (signer.transaction.group != null) {
      throw ArgumentError(
          'Atomic Transaction Composer group field must be zero');
    }
    if (status != ATCStatus.BUILDING) {
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
  void addMethodCal(MethodCallParams methodCall) {
    if (status != ATCStatus.BUILDING) {
      throw ArgumentError(
          'Atomic Transaction Composer must be in BUILDING stage');
    }

    final txns = methodCall.createTransactions();
    if (transactions.length + txns.length > MAX_GROUP_SIZE) {
      throw ArgumentError(
          'Atomic Transaction Composer cannot exceed $MAX_GROUP_SIZE transactions');
    }

    transactions.addAll(txns);
    methodMap[transactions.length - 1] = methodCall.method;
  }
}
