// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_transfer_transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetTransferTransactionResponse _$AssetTransferTransactionResponseFromJson(
    Map<String, dynamic> json) {
  return AssetTransferTransactionResponse(
    amount: json['amount'] as int? ?? 0,
    assetId: json['asset-id'] as int,
    closeAmount: json['close-amount'] as int? ?? 0,
    receiver: json['receiver'] as String,
  );
}

Map<String, dynamic> _$AssetTransferTransactionResponseToJson(
        AssetTransferTransactionResponse instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'asset-id': instance.assetId,
      'close-amount': instance.closeAmount,
      'receiver': instance.receiver,
    };
