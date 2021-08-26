import 'dart:convert';

import 'package:algorand_dart/algorand_dart.dart';

/// PeriodicPayment contract enables creating an account which allows the
/// withdrawal of a fixed amount of assets every fixed number of rounds to a
/// specific Algrorand Address. In addition, the contract allows to add
/// an expiryRound, after which the address can withdraw the rest of the assets.
class PeriodicPayment {
  static const referenceProgram =
      // ignore: lines_longer_than_80_chars
      'ASAHAQoLAAwNDiYCAQYg/ryguxRKWk6ntDikaBrIDmyhBby2B/xWUyXJVpX2ohMxECISMQEjDhAxAiQYJRIQMQQhBDECCBIQMQYoEhAxCTIDEjEHKRIQMQghBRIQMQkpEjEHMgMSEDECIQYNEDEIJRIQERA=';

  /// Create a new Periodic Payment.
  ///
  /// PeriodicPayment contract enables creating an account which allows the
  /// withdrawal of a fixed amount of assets every fixed number of rounds to a
  /// specific Algrorand Address. In addition, the contract allows to add an
  /// expiryRound, after which the address can withdraw the rest of the assets.
  static ContractTemplate create({
    required Address receiver,
    required int amount,
    required int withdrawingWindow,
    required int period,
    required int fee,
    required int expiryRound,
    String? lease,
  }) {
    final values = List.of([
      IntParameterValue(4, fee),
      IntParameterValue(5, period),
      IntParameterValue(7, withdrawingWindow),
      IntParameterValue(8, amount),
      IntParameterValue(9, expiryRound),
      BytesParameterValue.decodeBase64(
          12, lease != null ? lease : ContractTemplate.createRandomLease()),
      AddressParameterValue(15, receiver),
    ], growable: false);

    return ContractTemplate.inject(
      program: base64Decode(referenceProgram),
      values: values,
    );
  }

  /// Return the withdrawal transaction to be sent to the network.
  ///
  static Future<SignedTransaction> getWithdrawalTransaction({
    required ContractTemplate contract,
    required int firstValid,
    required String genesisHash,
    required int feePerByte,
  }) async {
    final data = ContractTemplate.readAndVerifyContract(
      program: contract.program,
      numInts: 7,
      numByteArrays: 2,
    );
    //final maxFee = data.intBlock[1];
    final period = data.intBlock[2];
    final withdrawingWindow = data.intBlock[4];
    final amount = data.intBlock[5];
    final lease = data.byteBlock[0];
    final receiver = Address(publicKey: data.byteBlock[1]);

    if (firstValid % period != 0) {
      throw ArgumentError(
        'invalid contract: firstValid must be divisible by the period',
      );
    }

    final lsig = LogicSignature(logic: contract.program);

    final tx = await (PaymentTransactionBuilder()
          ..sender = contract.address
          ..receiver = receiver
          ..suggestedFeePerByte = feePerByte
          ..firstValid = firstValid
          ..lastValid = firstValid + withdrawingWindow
          ..amount = amount
          ..genesisHashB64 = genesisHash
          ..lease = lease)
        .build();

    return lsig.signTransaction(transaction: tx);
  }
}
