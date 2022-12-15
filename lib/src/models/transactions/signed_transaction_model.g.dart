// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signed_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignedTransaction _$SignedTransactionFromJson(Map<String, dynamic> json) =>
    SignedTransaction(
      transaction: const TransactionSerializer()
          .fromJson(json['txn'] as Map<String, dynamic>),
      signature: const NullableByteArraySerializer().fromJson(json['sig']),
      logicSignature: json['lsig'] == null
          ? null
          : LogicSignature.fromJson(json['lsig'] as Map<String, dynamic>),
      transactionId: json['transaction-id'] as String?,
    )..authAddress = const AddressSerializer().fromJson(json['sgnr']);

Map<String, dynamic> _$SignedTransactionToJson(SignedTransaction instance) =>
    <String, dynamic>{
      'sig': const NullableByteArraySerializer().toJson(instance.signature),
      'txn': const TransactionSerializer().toJson(instance.transaction),
      'sgnr': const AddressSerializer().toJson(instance.authAddress),
      'lsig': instance.logicSignature?.toJson(),
      'transaction-id': instance.transactionId,
    };
