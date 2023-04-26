import 'dart:convert';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/algod/signed_transaction_with_ad.dart';
import 'package:algorand_dart/src/api/algod/transformers/transformers.dart';
import 'package:algorand_dart/src/api/converters/byte_array_to_b64_converter.dart';

class TransactionTransformer
    extends AlgodTransformer<SignedTransactionWithAD, Transaction> {
  final AlgodBlock block;

  TransactionTransformer(this.block);

  @override
  Transaction transform(SignedTransactionWithAD input) {
    final txn = input.txn.transaction;
    final data = input.applyData;

    return Transaction(
      id: txn.id,
      fee: txn.fee ?? BigInt.zero,
      genesisId: block.genesisId,
      genesisHash: block.genesisHash,
      firstValid: txn.firstValid ?? BigInt.zero,
      lastValid: txn.lastValid ?? BigInt.zero,
      sender: txn.sender?.encodedAddress ?? '',
      type: txn.type ?? '',
      note: const ByteArrayToB64Converter().fromJson(txn.note),
      group: const ByteArrayToB64Converter().fromJson(txn.group),
      lease: const ByteArrayToB64Converter().fromJson(txn.lease),
      rekeyTo: txn.rekeyTo?.encodedAddress,
      signature: TransactionSignature(
        signature: base64.encode(input.txn.signature ?? []),
      ),
      globalStateDelta: data?.evalDelta?.globalDelta ?? [],
      localStateDelta: data?.evalDelta?.localStateDelta ?? [],
      innerTxns: data?.evalDelta?.transactions
              .map((e) => transform(SignedTransactionWithAD(txn: input.txn)))
              .toList() ??
          [],
      logs: data?.evalDelta?.logs ?? [],
      closingAmount: data?.closingAmount.toInt(),
      senderRewards: data?.senderRewards.toInt(),
      receiverRewards: data?.receiverRewards.toInt(),
      closeRewards: data?.closeRewards.toInt(),
      createdAssetIndex: data?.configAsset.toInt(),
      createdApplicationIndex: data?.applicationId.toInt(),
      paymentTransaction: const PaymentTransactionTransformer().transform(txn),
      assetConfigTransaction:
          const AssetConfigTransactionTransformer().transform(txn),
      assetTransferTransaction:
          const AssetTransferTransactionTransformer().transform(txn),
      assetFreezeTransaction:
          const AssetFreezeTransactionTransformer().transform(txn),
      keyRegistrationTransaction:
          const KeyRegistrationTransactionTransformer().transform(txn),
      applicationTransaction:
          const ApplicationTransactionTransformer().transform(txn),
    );
  }
}
