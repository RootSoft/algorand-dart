// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dry_run_source_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DryRunSource _$DryRunSourceFromJson(Map<String, dynamic> json) => DryRunSource(
      appIndex: json['app-index'] as int?,
      fieldName: json['field-name'] as String?,
      source: json['source'] as String?,
      txnIndex: json['txn-index'] as int?,
    );

Map<String, dynamic> _$DryRunSourceToJson(DryRunSource instance) =>
    <String, dynamic>{
      'app-index': instance.appIndex,
      'field-name': instance.fieldName,
      'source': instance.source,
      'txn-index': instance.txnIndex,
    };
