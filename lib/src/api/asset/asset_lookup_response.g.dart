// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_lookup_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetResponse _$AssetResponseFromJson(Map<String, dynamic> json) =>
    AssetResponse(
      currentRound: json['current-round'] as int,
      asset: Asset.fromJson(json['asset'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AssetResponseToJson(AssetResponse instance) =>
    <String, dynamic>{
      'current-round': instance.currentRound,
      'asset': instance.asset,
    };
