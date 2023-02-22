// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_names_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoxNamesResponse _$BoxNamesResponseFromJson(Map<String, dynamic> json) =>
    BoxNamesResponse(
      applicationId: const BigIntSerializer().fromJson(json['application-id']),
      boxes: (json['boxes'] as List<dynamic>?)
              ?.map((e) => BoxDescriptor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      nextToken: json['next-token'] as String?,
    );

Map<String, dynamic> _$BoxNamesResponseToJson(BoxNamesResponse instance) =>
    <String, dynamic>{
      'application-id': const BigIntSerializer().toJson(instance.applicationId),
      'boxes': instance.boxes,
      'next-token': instance.nextToken,
    };
