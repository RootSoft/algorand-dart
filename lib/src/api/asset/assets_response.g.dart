// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetsResponse _$AssetsResponseFromJson(Map<String, dynamic> json) =>
    AssetsResponse(
      assets: (json['assets'] as List<dynamic>?)
              ?.map((e) => AssetHolding.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentRound: json['current-round'] as int? ?? 0,
      nextToken: json['next-token'] as String?,
    );

Map<String, dynamic> _$AssetsResponseToJson(AssetsResponse instance) =>
    <String, dynamic>{
      'assets': instance.assets,
      'current-round': instance.currentRound,
      'next-token': instance.nextToken,
    };
