// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_assets_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchAssetsResponse _$SearchAssetsResponseFromJson(
        Map<String, dynamic> json) =>
    SearchAssetsResponse(
      currentRound: json['current-round'] as int,
      nextToken: json['next-token'] as String?,
      assets: (json['assets'] as List<dynamic>)
          .map((e) => Asset.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchAssetsResponseToJson(
        SearchAssetsResponse instance) =>
    <String, dynamic>{
      'current-round': instance.currentRound,
      'next-token': instance.nextToken,
      'assets': instance.assets,
    };
