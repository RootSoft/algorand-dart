// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockResponse _$BlockResponseFromJson(Map<String, dynamic> json) =>
    BlockResponse(
      block: AlgodBlock.fromJson(json['block'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BlockResponseToJson(BlockResponse instance) =>
    <String, dynamic>{
      'block': instance.block,
    };
