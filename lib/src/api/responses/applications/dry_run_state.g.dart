// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dry_run_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DryRunState _$DryRunStateFromJson(Map<String, dynamic> json) => DryRunState(
      error: json['error'] as String? ?? '',
      line: json['line'] as int? ?? 0,
      pc: json['pc'] as int? ?? 0,
      scratch: (json['scratch'] as List<dynamic>?)
              ?.map((e) => TealValue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      stack: (json['stack'] as List<dynamic>?)
              ?.map((e) => TealValue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$DryRunStateToJson(DryRunState instance) =>
    <String, dynamic>{
      'error': instance.error,
      'line': instance.line,
      'pc': instance.pc,
      'scratch': instance.scratch,
      'stack': instance.stack,
    };
