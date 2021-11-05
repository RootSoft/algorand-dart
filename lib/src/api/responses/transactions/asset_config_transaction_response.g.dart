// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_config_transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetConfigTransactionResponse _$AssetConfigTransactionResponseFromJson(
        Map<String, dynamic> json) =>
    AssetConfigTransactionResponse(
      assetId: json['asset-id'] as int?,
      parameters: json['params'] == null
          ? null
          : AssetParameters.fromJson(json['params'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AssetConfigTransactionResponseToJson(
        AssetConfigTransactionResponse instance) =>
    <String, dynamic>{
      'asset-id': instance.assetId,
      'params': instance.parameters,
    };
