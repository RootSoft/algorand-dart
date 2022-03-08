// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_lookup_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationResponse _$ApplicationResponseFromJson(Map<String, dynamic> json) =>
    ApplicationResponse(
      currentRound: json['current-round'] as int? ?? 0,
      application: json['application'] == null
          ? null
          : Application.fromJson(json['application'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApplicationResponseToJson(
        ApplicationResponse instance) =>
    <String, dynamic>{
      'current-round': instance.currentRound,
      'application': instance.application,
    };
