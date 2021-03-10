// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingTransaction _$PendingTransactionFromJson(Map<String, dynamic> json) {
  return PendingTransaction(
    transaction:
        SignedTransaction.fromJson(json['txn'] as Map<String, dynamic>),
    poolError: json['pool-error'] as String,
    applicationIndex: json['application-index'] as int?,
    assetIndex: json['asset-index'] as int?,
    closeRewards: json['close-rewards'] as int?,
    closingAmount: json['closing-amount'] as int?,
    confirmedRound: json['confirmed-round'] as int?,
    receiverRewards: json['receiver-rewards'] as int?,
    senderRewards: json['sender-rewards'] as int?,
  );
}

Map<String, dynamic> _$PendingTransactionToJson(PendingTransaction instance) =>
    <String, dynamic>{
      'application-index': instance.applicationIndex,
      'asset-index': instance.assetIndex,
      'close-rewards': instance.closeRewards,
      'closing-amount': instance.closingAmount,
      'confirmed-round': instance.confirmedRound,
      'pool-error': instance.poolError,
      'receiver-rewards': instance.receiverRewards,
      'sender-rewards': instance.senderRewards,
      'txn': instance.transaction,
    };
