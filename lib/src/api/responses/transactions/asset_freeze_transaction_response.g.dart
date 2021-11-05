// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_freeze_transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetFreezeTransactionResponse _$AssetFreezeTransactionResponseFromJson(
        Map<String, dynamic> json) =>
    AssetFreezeTransactionResponse(
      address: json['address'] as String? ?? '',
      assetId: json['asset-id'] as int? ?? 0,
      newFreezeStatus: json['new-freeze-status'] as bool? ?? false,
    );

Map<String, dynamic> _$AssetFreezeTransactionResponseToJson(
        AssetFreezeTransactionResponse instance) =>
    <String, dynamic>{
      'address': instance.address,
      'asset-id': instance.assetId,
      'new-freeze-status': instance.newFreezeStatus,
    };
