// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signed_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignedTransaction _$SignedTransactionFromJson(Map<String, dynamic> json) {
  return SignedTransaction(
    signature: const SignatureSerializer().fromJson(json['sig'] as String),
    transaction: RawTransaction.fromJson(json['txn'] as Map<String, dynamic>),
  )..authAddress = const AddressSerializer().fromJson(json['sgnr'] as String?);
}

Map<String, dynamic> _$SignedTransactionToJson(SignedTransaction instance) =>
    <String, dynamic>{
      'sig': const SignatureSerializer().toJson(instance.signature),
      'txn': instance.transaction.toJson(),
      'sgnr': const AddressSerializer().toJson(instance.authAddress),
    };
