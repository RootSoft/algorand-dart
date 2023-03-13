// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applications_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationsResponse _$ApplicationsResponseFromJson(
        Map<String, dynamic> json) =>
    ApplicationsResponse(
      applications: (json['applications'] as List<dynamic>?)
              ?.map((e) => Application.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentRound: json['current-round'] as int? ?? 0,
      nextToken: json['next-token'] as String?,
    );

Map<String, dynamic> _$ApplicationsResponseToJson(
        ApplicationsResponse instance) =>
    <String, dynamic>{
      'applications': instance.applications,
      'current-round': instance.currentRound,
      'next-token': instance.nextToken,
    };
