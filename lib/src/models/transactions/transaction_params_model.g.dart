// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_params_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionParams _$TransactionParamsFromJson(Map<String, dynamic> json) =>
    TransactionParams(
      consensusVersion: json['consensus-version'] as String,
      fee: json['fee'] as int,
      genesisId: json['genesis-id'] as String,
      genesisHash:
          const NullableByteArraySerializer().fromJson(json['genesis-hash']),
      lastRound: json['last-round'] as int,
      minFee: json['min-fee'] as int,
    );

Map<String, dynamic> _$TransactionParamsToJson(TransactionParams instance) =>
    <String, dynamic>{
      'consensus-version': instance.consensusVersion,
      'fee': instance.fee,
      'genesis-id': instance.genesisId,
      'genesis-hash':
          const NullableByteArraySerializer().toJson(instance.genesisHash),
      'last-round': instance.lastRound,
      'min-fee': instance.minFee,
    };
