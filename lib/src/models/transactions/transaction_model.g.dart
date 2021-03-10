// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return Transaction(
    id: json['id'] as String,
    fee: json['fee'] as int,
    firstValid: json['first-valid'] as int,
    lastValid: json['last-valid'] as int,
    sender: json['sender'] as String,
    type: json['tx-type'] as String,
    signature: TransactionSignature.fromJson(
        json['signature'] as Map<String, dynamic>),
    closeRewards: json['close-rewards'] as int?,
    closingAmount: json['closing-amount'] as int?,
    confirmedRound: json['confirmed-round'] as int?,
    genesisHash: json['genesis-hash'] as String?,
    genesisId: json['genesis-id'] as String?,
    intraRoundOffset: json['intra-round-offset'] as int?,
    payment: json['payment-transaction'] == null
        ? null
        : Payment.fromJson(json['payment-transaction'] as Map<String, dynamic>),
    receiverRewards: json['receiver-rewards'] as int?,
    roundTime: json['round-time'] as int?,
    senderRewards: json['sender-rewards'] as int?,
    note: json['note'] as String?,
  );
}

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'close-rewards': instance.closeRewards,
      'closing-amount': instance.closingAmount,
      'confirmed-round': instance.confirmedRound,
      'fee': instance.fee,
      'first-valid': instance.firstValid,
      'genesis-hash': instance.genesisHash,
      'genesis-id': instance.genesisId,
      'id': instance.id,
      'intra-round-offset': instance.intraRoundOffset,
      'last-valid': instance.lastValid,
      'payment-transaction': instance.payment,
      'receiver-rewards': instance.receiverRewards,
      'round-time': instance.roundTime,
      'sender': instance.sender,
      'sender-rewards': instance.senderRewards,
      'signature': instance.signature,
      'tx-type': instance.type,
      'note': instance.note,
    };
