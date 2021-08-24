// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signed_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignedTransaction _$SignedTransactionFromJson(Map<String, dynamic> json) {
  return SignedTransaction(
    transaction: const TransactionSerializer()
        .fromJson(json['txn'] as Map<String, dynamic>),
    signature: const SignatureSerializer().fromJson(json['sig']),
  )..authAddress = const AddressSerializer().fromJson(json['sgnr']);
}

Map<String, dynamic> _$SignedTransactionToJson(SignedTransaction instance) =>
    <String, dynamic>{
      'sig': const SignatureSerializer().toJson(instance.signature),
      'txn': const TransactionSerializer().toJson(instance.transaction),
      'sgnr': const AddressSerializer().toJson(instance.authAddress),
    };
