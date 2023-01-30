// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentTransactionResponse _$PaymentTransactionResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentTransactionResponse(
      amount: const BigIntSerializer().fromJson(json['amount']),
      closeAmount:
          const NullableBigIntSerializer().fromJson(json['close-amount']),
      receiver: json['receiver'] as String,
      closeRemainderTo: json['close-remainder-to'] as String?,
    );

Map<String, dynamic> _$PaymentTransactionResponseToJson(
        PaymentTransactionResponse instance) =>
    <String, dynamic>{
      'amount': const BigIntSerializer().toJson(instance.amount),
      'close-amount':
          const NullableBigIntSerializer().toJson(instance.closeAmount),
      'close-remainder-to': instance.closeRemainderTo,
      'receiver': instance.receiver,
    };
