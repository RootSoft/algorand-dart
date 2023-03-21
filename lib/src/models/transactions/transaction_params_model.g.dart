// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_params_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionParams _$TransactionParamsFromJson(Map<String, dynamic> json) =>
    TransactionParams(
      consensusVersion: json['consensus-version'] as String,
      fee: const BigIntSerializer().fromJson(json['fee']),
      genesisId: json['genesis-id'] as String,
      genesisHash:
          const NullableByteArraySerializer().fromJson(json['genesis-hash']),
      lastRound: const BigIntSerializer().fromJson(json['last-round']),
      minFee: const BigIntSerializer().fromJson(json['min-fee']),
    );

Map<String, dynamic> _$TransactionParamsToJson(TransactionParams instance) =>
    <String, dynamic>{
      'consensus-version': instance.consensusVersion,
      'fee': const BigIntSerializer().toJson(instance.fee),
      'genesis-id': instance.genesisId,
      'genesis-hash':
          const NullableByteArraySerializer().toJson(instance.genesisHash),
      'last-round': const BigIntSerializer().toJson(instance.lastRound),
      'min-fee': const BigIntSerializer().toJson(instance.minFee),
    };
