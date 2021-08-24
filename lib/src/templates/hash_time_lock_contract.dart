import 'dart:convert';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/templates/contract_template.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';

/// Hash Time Locked Contract allows a user to receive the Algo prior to a
/// deadline (in terms of a round) by proving knowledge of a special value
/// or to forfeit the ability to claim, returning it to the payer.
///
/// This contract is usually used to perform cross-chained atomic swaps.
///
/// More formally, algos can be transfered under only two circumstances:
/// 1. To receiver if hash_function(arg_0) = hash_value
/// 2. To owner if txn.FirstValid &gt; expiry_round
class HashTimeLockContract {
  static const referenceProgram =
      // ignore: lines_longer_than_80_chars
      'ASAEBQEABiYDIP68oLsUSlpOp7Q4pGgayA5soQW8tgf8VlMlyVaV9qITAQYg5pqWHm8tX3rIZgeSZVK+mCNe0zNjyoiRi7nJOKkVtvkxASIOMRAjEhAxBzIDEhAxCCQSEDEJKBItASkSEDEJKhIxAiUNEBEQ';

  /// Create a new Hash Time Locked Contract.
  /// This allows a user to receive Algo prior to a deadline by proving
  /// knowledge of a special value or to forfeit the ability to claim,
  /// returning it to the payer.
  static ContractTemplate create({
    required Address owner,
    required Address receiver,
    required HashFunction hashFunction,
    required String hashImage,
    required int expiryRound,
    required int maxFee,
  }) {
    final values = List.of([
      IntParameterValue(3, maxFee),
      IntParameterValue(6, expiryRound),
      AddressParameterValue(10, receiver),
      BytesParameterValue.decodeBase64(42, hashImage),
      AddressParameterValue(45, owner),
      IntParameterValue(102, hashFunction.value),
    ], growable: false);

    return ContractTemplate.inject(
      program: base64Decode(referenceProgram),
      values: values,
    );
  }

  /// Read and verify the contract, and return the signed transaction
  static Future<SignedTransaction> getTransaction({
    required ContractTemplate contract,
    required String preImage,
    required int firstValid,
    required int lastValid,
    required String genesisHash,
    required int feePerByte,
  }) async {
    final data = ContractTemplate.readAndVerifyContract(
      program: contract.program,
      numInts: 4,
      numByteArrays: 3,
    );
    //final maxFee = data.intBlock[0];
    final receiver = Address(publicKey: data.byteBlock[0]);
    final hashImage = data.byteBlock[1];
    //final hashFn = contract.program[contract.program.length - 15];

    // Validate hash function
    final computedImage = sha256.convert(base64Decode(preImage));
    if (!const ListEquality().equals(computedImage.bytes, hashImage)) {
      throw AlgorandException(message: 'Unable to verify SHA-256 preImage');
    }

    final tx = await (PaymentTransactionBuilder()
          ..sender = contract.address
          ..firstValid = firstValid
          ..lastValid = lastValid
          ..genesisHashB64 = genesisHash
          ..amount = 0
          ..suggestedFeePerByte = feePerByte
          ..closeRemainderTo = receiver)
        .build();

    final args = List.of([base64Decode(preImage)], growable: false);
    final signature = LogicSignature(logic: contract.program, arguments: args);
    return SignedTransaction(transaction: tx, logicSignature: signature);
  }
}

enum HashFunction { SHA256, KECCAK256 }

extension HashFunctionExtension on HashFunction {
  int get value {
    switch (this) {
      case HashFunction.SHA256:
        return 1;
      case HashFunction.KECCAK256:
        return 2;
    }
  }
}
