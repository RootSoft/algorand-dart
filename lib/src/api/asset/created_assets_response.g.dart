// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'created_assets_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatedAssetsResponse _$CreatedAssetsResponseFromJson(
        Map<String, dynamic> json) =>
    CreatedAssetsResponse(
      assets: (json['assets'] as List<dynamic>?)
              ?.map((e) => Asset.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentRound: json['current-round'] as int? ?? 0,
      nextToken: json['next-token'] as String?,
    );

Map<String, dynamic> _$CreatedAssetsResponseToJson(
        CreatedAssetsResponse instance) =>
    <String, dynamic>{
      'assets': instance.assets,
      'current-round': instance.currentRound,
      'next-token': instance.nextToken,
    };
