import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/exceptions/exceptions.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/transaction_builders.dart';
import 'package:algorand_dart/src/templates/templates.dart';

/// A limit order allows a user to exchange some number of assets for some
/// number of algos.
///
/// Fund the contract with some number of Algos to limit the maximum number of
/// Algos you're willing to trade for some other asset.
/// Works on two cases:
/// - trading Algos for some other asset
/// - closing out Algos back to the originator after a timeout
///
/// trade case, a 2 transaction group:
/// - gtxn[0] (this txn) Algos from Me to Other
/// - gtxn[1] asset from Other to Me
///
/// We want to get at least some amount of the other asset per our Algos
/// gtxn[1].AssetAmount / gtxn[0].Amount &gt;= N / D
/// ===
/// gtxn[1].AssetAmount * D &gt;= gtxn[0].Amount * N
/// close-out case:
/// - txn alone, close out value after timeout
class LimitOrder {
  static const referenceProgram =
      // ignore: lines_longer_than_80_chars
      'ASAKAAEFAgYEBwgJCiYBIP68oLsUSlpOp7Q4pGgayA5soQW8tgf8VlMlyVaV9qITMRYiEjEQIxIQMQEkDhAyBCMSQABVMgQlEjEIIQQNEDEJMgMSEDMBECEFEhAzAREhBhIQMwEUKBIQMwETMgMSEDMBEiEHHTUCNQExCCEIHTUENQM0ATQDDUAAJDQBNAMSNAI0BA8QQAAWADEJKBIxAiEJDRAxBzIDEhAxCCISEBA=';

  /// Create a new Dynamic Fee contract.
  /// DynamicFee contract allows you to create a transaction without
  /// specifying the fee. The fee will be determined at the moment of transfer.
  static ContractTemplate create({
    required Address owner,
    required int assetId,
    required int ratn,
    required int ratd,
    required int expirationRound,
    required int minTrade,
    required int maxFee,
  }) {
    final values = List.of([
      IntParameterValue(5, maxFee),
      IntParameterValue(7, minTrade),
      IntParameterValue(9, assetId),
      IntParameterValue(10, ratd),
      IntParameterValue(11, ratn),
      IntParameterValue(12, expirationRound),
      AddressParameterValue(16, owner),
    ], growable: false);

    return ContractTemplate.inject(
      program: base64Decode(referenceProgram),
      values: values,
    );
  }

  /// Creates a group transaction array which transfer funds according to the
  /// contract's ratio
  static Future<Uint8List> getSwapAssetsTransaction({
    required ContractTemplate contract,
    required int assetAmount,
    required int microAlgoAmount,
    required Account sender,
    required int firstValid,
    required int lastValid,
    required String genesisHash,
    required int feePerByte,
  }) async {
    final data = ContractTemplate.readAndVerifyContract(
      program: contract.program,
      numInts: 10,
      numByteArrays: 1,
    );

    final owner = Address(publicKey: data.byteBlock[0]);
    final maxFee = data.intBlock[2];
    final minTrade = data.intBlock[4];
    final assetId = data.intBlock[6];
    final ratd = data.intBlock[7];
    final ratn = data.intBlock[8];

    if (assetAmount * ratd != microAlgoAmount * ratn) {
      throw ArgumentError(
        'The exchange ratio of assets to microalgos must be exactly',
      );
    }

    if (microAlgoAmount < minTrade) {
      throw ArgumentError(
        'At least $minTrade microalgos must be requested.',
      );
    }

    final tx1 = await (PaymentTransactionBuilder()
          ..sender = contract.address
          ..suggestedFeePerByte = feePerByte
          ..firstValid = firstValid
          ..lastValid = lastValid
          ..genesisHashB64 = genesisHash
          ..amount = microAlgoAmount
          ..receiver = sender.address)
        .build();

    final tx2 = await (AssetTransferTransactionBuilder()
          ..sender = sender.address
          ..receiver = owner
          ..amount = assetAmount
          ..suggestedFeePerByte = feePerByte
          ..firstValid = firstValid
          ..lastValid = lastValid
          ..genesisHashB64 = genesisHash
          ..assetId = assetId)
        .build();

    if (tx1.fee! > maxFee || tx2.fee! > maxFee) {
      throw AlgorandException(
        message: 'Transaction fee is greater than maxFee',
      );
    }

    AtomicTransfer.group([tx1, tx2]);

    final lsig = LogicSignature(logic: contract.program);
    final stx1 = SignedTransaction(transaction: tx1, logicSignature: lsig);
    final stx2 = await tx2.sign(sender);

    return Uint8List.fromList([
      ...Encoder.encodeMessagePack(stx1.toMessagePack()),
      ...Encoder.encodeMessagePack(stx2.toMessagePack())
    ]);
  }
}
