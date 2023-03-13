// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_log_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationLogData _$ApplicationLogDataFromJson(Map<String, dynamic> json) =>
    ApplicationLogData(
      logs:
          (json['logs'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      txId: json['txid'] as String?,
    );

Map<String, dynamic> _$ApplicationLogDataToJson(ApplicationLogData instance) =>
    <String, dynamic>{
      'logs': instance.logs,
      'txid': instance.txId,
    };
