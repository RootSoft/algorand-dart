// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_applications_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchApplicationsResponse _$SearchApplicationsResponseFromJson(
        Map<String, dynamic> json) =>
    SearchApplicationsResponse(
      applications: (json['applications'] as List<dynamic>?)
              ?.map((e) => Application.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentRound: json['current-round'] as int,
      nextToken: json['next-token'] as String?,
    );

Map<String, dynamic> _$SearchApplicationsResponseToJson(
        SearchApplicationsResponse instance) =>
    <String, dynamic>{
      'current-round': instance.currentRound,
      'next-token': instance.nextToken,
      'applications': instance.applications,
    };
