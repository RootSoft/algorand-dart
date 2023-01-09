// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mini_asset_holding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MiniAssetHolding _$MiniAssetHoldingFromJson(Map<String, dynamic> json) =>
    MiniAssetHolding(
      address: json['address'] as String,
      amount: const BigIntSerializer().fromJson(json['amount']),
      isFrozen: json['is-frozen'] as bool,
      deleted: json['deleted'] as bool?,
      optedInAtRound: json['opted-in-at-round'] as int?,
      optedOutAtRound: json['opted-out-at-round'] as int?,
    );

Map<String, dynamic> _$MiniAssetHoldingToJson(MiniAssetHolding instance) =>
    <String, dynamic>{
      'address': instance.address,
      'amount': const BigIntSerializer().toJson(instance.amount),
      'deleted': instance.deleted,
      'is-frozen': instance.isFrozen,
      'opted-in-at-round': instance.optedInAtRound,
      'opted-out-at-round': instance.optedOutAtRound,
    };
