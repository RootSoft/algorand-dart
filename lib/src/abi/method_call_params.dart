import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';

class MethodCallParams {
  /// if the abi type argument number > 15, then the abi types after 14th
  /// should be wrapped in a tuple
  static const MAX_ABI_ARG_TYPE_LEN = 15;

  static const FOREIGN_OBJ_ABI_UINT_SIZE = 8;

  final int applicationId;
  final OnCompletion onCompletion;
  final AbiMethod method;
  final List<dynamic> methodArgs;

  final List<Address> foreignAccounts;
  final List<int> foreignAssets;
  final List<int> foreignApps;
  final List<AppBoxReference> appBoxReferences;

  final TEALProgram? approvalProgram;
  final TEALProgram? clearStateProgram;
  final StateSchema? globalStateSchema;
  final StateSchema? localStateSchema;
  final int? extraPages;

  final TxnSigner signer;
  final Address sender;
  final BigInt? fee;
  final BigInt? flatFee;
  final BigInt firstValid;
  final BigInt lastValid;
  final Uint8List? note;
  final Uint8List? lease;
  final Address? rekeyTo;
  final String genesisId;
  final Uint8List? genesisHash;

  MethodCallParams._internal({
    required this.applicationId,
    required this.onCompletion,
    required this.method,
    required this.methodArgs,
    required this.foreignAccounts,
    required this.foreignAssets,
    required this.foreignApps,
    required this.appBoxReferences,
    required this.approvalProgram,
    required this.clearStateProgram,
    required this.globalStateSchema,
    required this.localStateSchema,
    required this.extraPages,
    required this.signer,
    required this.sender,
    required this.fee,
    required this.flatFee,
    required this.firstValid,
    required this.lastValid,
    required this.note,
    required this.lease,
    required this.rekeyTo,
    required this.genesisId,
    required this.genesisHash,
  });

  factory MethodCallParams({
    required int applicationId,
    required Address sender,
    required TxnSigner signer,
    OnCompletion? onCompletion = OnCompletion.NO_OP_OC,
    AbiMethod? method,
    String? genesisId,
    Uint8List? genesisHash,
    BigInt? firstValid,
    BigInt? lastValid,
    BigInt? fee,
    BigInt? flatFee,
    List<dynamic>? methodArgs,
    TEALProgram? approvalProgram,
    TEALProgram? clearStateProgram,
    StateSchema? globalStateSchema,
    StateSchema? localStateSchema,
    int? extraPages,
    List<Address>? foreignAccounts,
    List<int>? foreignAssets,
    List<int>? foreignApps,
    List<AppBoxReference>? appBoxReferences,
    Uint8List? lease,
    Uint8List? note,
    Address? rekeyTo,
    TransactionParams? params,
  }) {
    if (method == null || onCompletion == null) {
      throw ArgumentError(
          'Method call builder error: some required field not added');
    }

    if (params != null) {
      genesisId = params.genesisId;
      genesisHash = params.genesisHash;
      firstValid = params.lastRound;
      lastValid = params.lastRound + BigInt.from(1000);
      fee = params.fee;
    } else {
      if (genesisId == null ||
          genesisHash == null ||
          firstValid == null ||
          lastValid == null ||
          (fee == null && flatFee == null)) {
        throw ArgumentError(
            'Method call builder error: some required field not added');
      }
    }

    if (fee != null && flatFee != null) {
      throw ArgumentError('Cannot set both fee and flatFee');
    }

    if (method.arguments.length != methodArgs?.length) {
      throw ArgumentError('Incorrect method arg number provided.');
    }

    if (applicationId == 0) {
      if (approvalProgram == null ||
          clearStateProgram == null ||
          globalStateSchema == null ||
          localStateSchema == null) {
        throw ArgumentError(
            'One of the following required params for application creation is missing');
      }
    } else if (onCompletion == OnCompletion.UPDATE_APPLICATION_OC) {
      if (approvalProgram == null || clearStateProgram == null) {
        throw ArgumentError(
            'approvalProgram or clearStateProgram argument is missing.');
      }

      if (globalStateSchema != null ||
          localStateSchema != null ||
          extraPages != null) {
        throw ArgumentError(
            'globalStateSchema, localStateSchema or extraPages argument is missing.');
      }
    } else {
      if (approvalProgram != null ||
          clearStateProgram != null ||
          globalStateSchema != null ||
          localStateSchema != null ||
          extraPages != null) {
        throw ArgumentError(
            'One of the following application creation parameters were set on a non-creation call: '
            'approvalProgram, clearProgram, globalStateSchema, localStateSchema, extraPages');
      }
    }

    return MethodCallParams._internal(
      applicationId: applicationId,
      method: method,
      methodArgs: List.from(methodArgs ?? []),
      sender: sender,
      signer: signer,
      genesisId: genesisId,
      genesisHash: genesisHash,
      firstValid: firstValid,
      lastValid: lastValid,
      fee: fee,
      flatFee: flatFee,
      onCompletion: onCompletion,
      approvalProgram: approvalProgram,
      clearStateProgram: clearStateProgram,
      globalStateSchema: globalStateSchema,
      localStateSchema: localStateSchema,
      extraPages: extraPages,
      foreignAccounts: List<Address>.from(foreignAccounts ?? <Address>[]),
      foreignAssets: List<int>.from(foreignAssets ?? <int>[]),
      foreignApps: List<int>.from(foreignApps ?? <int>[]),
      appBoxReferences: List<AppBoxReference>.from(
        appBoxReferences ?? <AppBoxReference>[],
      ),
      lease: lease,
      note: note,
      rekeyTo: rekeyTo,
    );
  }

  /// Create the transactions which will carry out the specified method call.
  /// The list of transactions returned by this function will have the same
  /// length as method.getTxnCallCount().
  Future<List<TransactionWithSigner>> createTransactions() async {
    final encodedABIArgs = <Uint8List>[];
    encodedABIArgs.add(method.selector);

    var methodArgs = [];
    var methodAbiTypes = <AbiType>[];

    final transactionArgs = <TransactionWithSigner>[];
    final foreignAccounts = List<Address>.of(this.foreignAccounts);
    final foreignAssets = List<int>.of(this.foreignAssets);
    final foreignApps = List<int>.of(this.foreignApps);
    final appBoxReferences = List<AppBoxReference>.of(this.appBoxReferences);

    for (var i = 0; i < method.arguments.length; i++) {
      final arg = method.arguments[i];
      final methodArg = this.methodArgs[i];
      final parsedType = arg.parsedType;
      if (parsedType == null && methodArg is TransactionWithSigner) {
        if (!_checkTransactionType(methodArg, arg.type)) {
          throw ArgumentError(
              'expected transaction type $parsedType not match with given ');
        }

        transactionArgs.add(methodArg);
      } else if (AbiMethod.RefArgTypes.contains(arg.type)) {
        int index;
        if (arg.type == AbiMethod.RefTypeAccount) {
          final abiAddressT = TypeAddress();
          final accountAddress =
              abiAddressT.decode(abiAddressT.encode(methodArg));
          index = _populateForeignArrayIndex(
              accountAddress, foreignAccounts, sender);
        } else if (arg.type == AbiMethod.RefTypeAsset) {
          final abiUintT = TypeUint(64);
          final assetId = abiUintT.decode(abiUintT.encode(methodArg)) as BigInt;
          index =
              _populateForeignArrayIndex(assetId.toInt(), foreignAssets, null);
        } else if (arg.type == AbiMethod.RefTypeApplication) {
          final abiUintT = TypeUint(64);
          final appId = abiUintT.decode(abiUintT.encode(methodArg)) as BigInt;
          index = _populateForeignArrayIndex(
              appId.toInt(), foreignApps, applicationId);
        } else {
          throw ArgumentError(
              'Cannot add method call in ATC: ForeignArray arg type not matching');
        }

        methodArgs.add(index);
        methodAbiTypes.add(TypeUint(FOREIGN_OBJ_ABI_UINT_SIZE));
      } else if (parsedType != null) {
        methodArgs.add(methodArg);
        methodAbiTypes.add(parsedType);
      } else {
        throw ArgumentError(
            'error: the type of method argument is a transaction-type, but no transaction-with-signer provided');
      }
    }

    if (methodArgs.length > MAX_ABI_ARG_TYPE_LEN) {
      final wrappedABITypeList = <AbiType>[];
      final wrappedValueList = [];

      for (var i = MAX_ABI_ARG_TYPE_LEN - 1; i < methodArgs.length; i++) {
        wrappedABITypeList.add(methodAbiTypes[i]);
        wrappedValueList.add(methodArgs[i]);
      }

      final tupleT = TypeTuple(wrappedABITypeList);
      methodAbiTypes = methodAbiTypes.sublist(0, MAX_ABI_ARG_TYPE_LEN - 1);
      methodAbiTypes.add(tupleT);
      methodArgs = methodArgs.sublist(0, MAX_ABI_ARG_TYPE_LEN - 1);
      methodArgs.add(wrappedValueList);
    }

    for (var i = 0; i < methodArgs.length; i++) {
      encodedABIArgs.add(methodAbiTypes[i].encode(methodArgs[i]));
    }

    final tx = await (ApplicationCreateTransactionBuilder(onCompletion)
          ..firstValid = firstValid
          ..lastValid = lastValid
          ..genesisHash = genesisHash
          ..genesisId = genesisId
          ..suggestedFeePerByte = fee
          ..flatFee = flatFee
          ..note = note
          ..lease = lease
          ..rekeyTo = rekeyTo
          ..sender = sender
          ..arguments = encodedABIArgs
          ..accounts = foreignAccounts
          ..foreignApps = foreignApps
          ..foreignAssets = foreignAssets
          ..appBoxReferences = appBoxReferences
          ..approvalProgram = approvalProgram
          ..clearStateProgram = clearStateProgram
          ..globalStateSchema = globalStateSchema
          ..localStateSchema = localStateSchema)
        .build();

    tx.applicationId = applicationId;
    tx.extraPages = extraPages;

    final methodCall = TransactionWithSigner(transaction: tx, signer: signer);
    transactionArgs.add(methodCall);
    return transactionArgs;
  }

  static bool _checkTransactionType(TransactionWithSigner tws, String txnType) {
    if (txnType == AbiMethod.TxAnyType) return true;
    return tws.transaction.type == txnType;
  }

  /// Add a value to an application call's foreign array.
  /// The addition will be as compact as possible,
  /// and this function will return an index that can be used to reference
  /// `objectToBeAdded` in `objectArray`.
  ///
  /// @param objectToBeAdded - The value to add to the array.
  /// If this value is already present in the array, it will not be added again
  /// Instead, the existing index will be returned.
  ///
  /// @param objectArray - The existing foreign array.
  /// This input may be modified to append `valueToAdd`.
  ///
  /// @param zerothObject - If provided, this value indicated two things:
  /// the 0 value is special for this array, so all indexes into `objectArray`
  /// must start at 1; additionally, if `objectToBeAdded` equals`zerothValue`,
  /// then `objectToBeAdded` will not be added to the array, and instead the 0
  /// indexes will be returned.
  ///
  /// @return An index that can be used to reference `valueToAdd` in `array`.
  static int _populateForeignArrayIndex<T>(
    T objectToBeAdded,
    List<T> objectArray,
    T? zerothObject,
  ) {
    if (objectToBeAdded == zerothObject) {
      return 0;
    }

    final startFrom = zerothObject == null ? 0 : 1;
    final searchInListIndex = objectArray.indexOf(objectToBeAdded);
    if (searchInListIndex != -1) {
      return startFrom + searchInListIndex;
    }

    objectArray.add(objectToBeAdded);
    return objectArray.length - 1 + startFrom;
  }
}
