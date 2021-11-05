// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_logs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationLogsResponse _$ApplicationLogsResponseFromJson(
        Map<String, dynamic> json) =>
    ApplicationLogsResponse(
      logData: (json['log-data'] as List<dynamic>?)
              ?.map(
                  (e) => ApplicationLogData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      applicationId: json['application-id'] as int?,
      currentRound: json['current-round'] as int?,
      nextToken: json['next-token'] as String?,
    );

Map<String, dynamic> _$ApplicationLogsResponseToJson(
        ApplicationLogsResponse instance) =>
    <String, dynamic>{
      'application-id': instance.applicationId,
      'current-round': instance.currentRound,
      'log-data': instance.logData,
      'next-token': instance.nextToken,
    };
