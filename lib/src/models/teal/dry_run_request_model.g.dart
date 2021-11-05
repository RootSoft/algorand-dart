// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dry_run_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DryRunRequest _$DryRunRequestFromJson(Map<String, dynamic> json) =>
    DryRunRequest(
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map(
                  (e) => AccountInformation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      applications: (json['apps'] as List<dynamic>?)
              ?.map((e) => Application.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      latestTimestamp: json['latest-timestamp'] as int?,
      protocolVersion: json['protocol-version'] as String?,
      round: json['round'] as int?,
      sources: (json['sources'] as List<dynamic>?)
              ?.map((e) => DryRunSource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      transactions: (json['txns'] as List<dynamic>?)
              ?.map(
                  (e) => SignedTransaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DryRunRequestToJson(DryRunRequest instance) =>
    <String, dynamic>{
      'accounts': instance.accounts.map((e) => e.toJson()).toList(),
      'apps': instance.applications.map((e) => e.toJson()).toList(),
      'latest-timestamp': instance.latestTimestamp,
      'protocol-version': instance.protocolVersion,
      'round': instance.round,
      'sources': instance.sources.map((e) => e.toJson()).toList(),
      'txns': instance.transactions.map((e) => e.toJson()).toList(),
    };
