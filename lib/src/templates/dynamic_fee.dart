import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';

/// DynamicFee contract allows you to create a transaction without
/// specifying the fee. The fee will be determined at the moment of transfer.
class DynamicFee {
  static const referenceProgram =
      // ignore: lines_longer_than_80_chars
      'ASAFAgEFBgcmAyD+vKC7FEpaTqe0OKRoGsgObKEFvLYH/FZTJclWlfaiEyDmmpYeby1feshmB5JlUr6YI17TM2PKiJGLuck4qRW2+QEGMgQiEjMAECMSEDMABzEAEhAzAAgxARIQMRYjEhAxECMSEDEHKBIQMQkpEhAxCCQSEDECJRIQMQQhBBIQMQYqEhA=';

  /// Create a new Dynamic Fee contract.
  /// DynamicFee contract allows you to create a transaction without
  /// specifying the fee. The fee will be determined at the moment of transfer.
  static ContractTemplate create({
    required Address receiver,
    required int amount,
    required int firstValid,
    required Address closeTo,
    int? lastValid,
    String? lease,
  }) {
    final values = List.of([
      IntParameterValue(5, amount),
      IntParameterValue(6, firstValid),
      IntParameterValue(7, lastValid != null ? lastValid : firstValid + 1000),
      AddressParameterValue(11, receiver),
      AddressParameterValue(44, closeTo),
      BytesParameterValue.decodeBase64(
        76,
        lease != null ? lease : ContractTemplate.createRandomLease(),
      ),
    ], growable: false);

    return ContractTemplate.inject(
      program: base64Decode(referenceProgram),
      values: values,
    );
  }

  /// Return the main transaction and signed logic needed to complete the
  /// transfer. These should be sent to the fee payer, who can use
  /// get_transactions() to update fields and create the auxiliary transaction.
  ///
  /// The transaction and logicsig should be sent to the other party as base64
  /// encoded objects:
  static Future<SignedDynamicFee> sign({
    required ContractTemplate contract,
    required Account sender,
    required String genesisHash,
  }) async {
    final data = ContractTemplate.readAndVerifyContract(
      program: contract.program,
      numInts: 5,
      numByteArrays: 3,
    );

    final receiver = Address(publicKey: data.byteBlock[0]);
    final closeTo = Address(publicKey: data.byteBlock[1]);
    final lease = data.byteBlock[2];

    final amount = data.intBlock[2];
    final firstValid = data.intBlock[3];
    final lastValid = data.intBlock[4];

    final tx = await (PaymentTransactionBuilder()
          ..sender = sender.address
          ..flatFee = 1000
          ..firstValid = firstValid
          ..lastValid = lastValid
          ..genesisHashB64 = genesisHash
          ..amount = amount
          ..receiver = receiver
          ..closeRemainderTo = closeTo
          ..lease = lease)
        .build();

    final lsig = LogicSignature(logic: contract.program);
    final signedLsig = await lsig.sign(account: sender);

    return SignedDynamicFee(transaction: tx, signature: signedLsig);
  }

  /// Create and sign the secondary dynamic fee transaction, update
  /// transaction fields, and sign as the fee payer; return both
  /// transactions ready to be sent.
  static Future<Uint8List> getReimbursementTransactions({
    required RawTransaction transaction,
    required LogicSignature signature,
    required Account account,
    required int feePerByte,
  }) async {
    await transaction.setFeeByFeePerByte(feePerByte);

    final reimbursement = await (PaymentTransactionBuilder()
          ..sender = account.address
          ..suggestedFeePerByte = feePerByte
          ..firstValid = transaction.firstValid
          ..lastValid = transaction.lastValid
          ..genesisId = transaction.genesisId
          ..genesisHash = transaction.genesisHash
          ..amount = transaction.fee
          ..receiver = transaction.sender)
        .build();

    reimbursement.lease = transaction.lease;
    await reimbursement.setFeeByFeePerByte(feePerByte);

    AtomicTransfer.group([reimbursement, transaction]);

    final stx1 = SignedTransaction(
      transaction: transaction,
      logicSignature: signature,
    );
    final stx2 = await reimbursement.sign(account);

    return Uint8List.fromList([
      ...Encoder.encodeMessagePack(stx2.toMessagePack()),
      ...Encoder.encodeMessagePack(stx1.toMessagePack())
    ]);
  }
}

class SignedDynamicFee {
  final RawTransaction transaction;
  final LogicSignature signature;

  SignedDynamicFee({required this.transaction, required this.signature});
}
