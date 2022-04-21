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
    );

Map<String, dynamic> _$CreatedAssetsResponseToJson(
        CreatedAssetsResponse instance) =>
    <String, dynamic>{
      'assets': instance.assets,
    };
