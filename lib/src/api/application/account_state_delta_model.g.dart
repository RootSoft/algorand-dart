// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_state_delta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountStateDelta _$AccountStateDeltaFromJson(Map<String, dynamic> json) =>
    AccountStateDelta(
      address: json['address'] as String?,
      delta: (json['delta'] as List<dynamic>?)
              ?.map(
                  (e) => EvalDeltaKeyValue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$AccountStateDeltaToJson(AccountStateDelta instance) =>
    <String, dynamic>{
      'address': instance.address,
      'delta': instance.delta,
    };
