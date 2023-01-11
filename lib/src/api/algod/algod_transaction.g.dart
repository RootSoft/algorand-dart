// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'algod_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlgodTransaction _$AlgodTransactionFromJson(Map<String, dynamic> json) =>
    AlgodTransaction(
      hgi: json['hgi'] as bool? ?? false,
      transaction: const TransactionSerializer()
          .fromJson(json['txn'] as Map<String, dynamic>),
      signature: const NullableByteArraySerializer().fromJson(json['sig']),
      dt: json['dt'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AlgodTransactionToJson(AlgodTransaction instance) =>
    <String, dynamic>{
      'hgi': instance.hgi,
      'sig': const NullableByteArraySerializer().toJson(instance.signature),
      'txn': const TransactionSerializer().toJson(instance.transaction),
      'dt': instance.dt,
    };
