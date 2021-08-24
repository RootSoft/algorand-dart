import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/templates/contract_template.dart';

/// Split allows locking algos in an account which allows transfering to two
/// predefined addresses in a specified ratio such that for the given ratn and
/// ratd parameters we have:
///
/// first_recipient_amount * rat_2 == second_recipient_amount * rat_1
///
/// Split also has an expiry round, after which the owner can transfer back
/// the funds.
class Split {
  static const referenceProgram =
      // ignore: lines_longer_than_80_chars
      'ASAIAQUCAAYHCAkmAyDYHIR7TIW5eM/WAZcXdEDqv7BD+baMN6i2/A5JatGbNCDKsaoZHPQ3Zg8zZB/BZ1oDgt77LGo5np3rbto3/gloTyB40AS2H3I72YCbDk4hKpm7J7NnFy2Xrt39TJG0ORFg+zEQIhIxASMMEDIEJBJAABkxCSgSMQcyAxIQMQglEhAxAiEEDRAiQAAuMwAAMwEAEjEJMgMSEDMABykSEDMBByoSEDMACCEFCzMBCCEGCxIQMwAIIQcPEBA=';

  /// Create a new Split Contract.
  /// Split allows locking algos in an account which allows transfering to two
  /// predefined addresses in a specified ratio such that for the given ratn and
  /// ratd parameters we have:
  ///
  /// first_recipient_amount * rat_2 == second_recipient_amount * rat_1
  ///
  /// Split also has an expiry round, after which the owner can transfer back
  /// the funds.
  static ContractTemplate create({
    required Address owner,
    required Address receiver1,
    required Address receiver2,
    required int rat1,
    required int rat2,
    required int expiryRound,
    required int minPay,
    required int maxFee,
  }) {
    final values = List.of([
      IntParameterValue(4, maxFee),
      IntParameterValue(7, expiryRound),
      IntParameterValue(8, rat2),
      IntParameterValue(9, rat1),
      IntParameterValue(10, minPay),
      AddressParameterValue(14, owner),
      AddressParameterValue(47, receiver1),
      AddressParameterValue(80, receiver2),
    ], growable: false);

    return ContractTemplate.inject(
      program: base64Decode(referenceProgram),
      values: values,
    );
  }

  /// Read and verify the contract, and return the signed transaction
  static Future<Uint8List> getTransactions({
    required ContractTemplate contract,
    required int amount,
    required int firstValid,
    required int lastValid,
    required String genesisHash,
    required int feePerByte,
  }) async {
    final data = ContractTemplate.readAndVerifyContract(
      program: contract.program,
      numInts: 8,
      numByteArrays: 3,
    );

    //final maxFee = data.intBlock[1];
    final rat1 = data.intBlock[6];
    final rat2 = data.intBlock[5];
    final minTrade = data.intBlock[7];

    final fraction = (rat1.toDouble() / (rat1 + rat2).toDouble());
    final amountReceiverOne = (fraction * amount).round();
    final amountReceiverTwo = ((1.0 - fraction) * amount).round();

    if (amount - amountReceiverOne - amountReceiverTwo != 0) {
      throw AlgorandException(
        message:
            'Unable to exactly split $amount using the contract ratio of $rat1 / $rat2',
      );
    }

    if (amountReceiverOne < minTrade) {
      throw AlgorandException(
        message: 'Receiver one must receive at least $minTrade',
      );
    }

    final rcv1 = BigInt.from(amountReceiverOne) * BigInt.from(rat2);
    final rcv2 = BigInt.from(amountReceiverTwo) * BigInt.from(rat1);

    if (rcv1 != rcv2) {
      throw AlgorandException(
        message: 'The token split must be exactly',
      );
    }

    final receiver1 = Address(publicKey: data.byteBlock[1]);
    final receiver2 = Address(publicKey: data.byteBlock[2]);

    // 2220000
    final tx1 = await (PaymentTransactionBuilder()
          ..sender = contract.address
          ..receiver = receiver1
          ..suggestedFeePerByte = feePerByte
          ..amount = amountReceiverOne
          ..firstValid = firstValid
          ..lastValid = lastValid
          ..genesisHashB64 = genesisHash)
        .build();

    final tx2 = await (PaymentTransactionBuilder()
          ..sender = contract.address
          ..receiver = receiver2
          ..suggestedFeePerByte = feePerByte
          ..amount = amountReceiverTwo
          ..firstValid = firstValid
          ..lastValid = lastValid
          ..genesisHashB64 = genesisHash)
        .build();

    final signature = LogicSignature(logic: contract.program);
    AtomicTransfer.group([tx1, tx2]);
    final stx1 = SignedTransaction(transaction: tx1, logicSignature: signature);
    final stx2 = SignedTransaction(transaction: tx2, logicSignature: signature);

    return Uint8List.fromList([
      ...Encoder.encodeMessagePack(stx1.toMessagePack()),
      ...Encoder.encodeMessagePack(stx2.toMessagePack())
    ]);
  }
}
