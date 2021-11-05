// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dry_run_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DryRunResponse _$DryRunResponseFromJson(Map<String, dynamic> json) =>
    DryRunResponse(
      error: json['error'] as String? ?? '',
      protocolVersion: json['protocol-version'] as String? ?? '',
      transactions: (json['txns'] as List<dynamic>?)
              ?.map((e) => DryRunTxResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$DryRunResponseToJson(DryRunResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'protocol-version': instance.protocolVersion,
      'txns': instance.transactions,
    };
