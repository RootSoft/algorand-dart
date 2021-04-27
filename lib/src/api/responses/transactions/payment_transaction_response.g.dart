// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentTransactionResponse _$PaymentTransactionResponseFromJson(
    Map<String, dynamic> json) {
  return PaymentTransactionResponse(
    amount: json['amount'] as int? ?? 0,
    closeAmount: json['close-amount'] as int? ?? 0,
    receiver: json['receiver'] as String,
  );
}

Map<String, dynamic> _$PaymentTransactionResponseToJson(
        PaymentTransactionResponse instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'close-amount': instance.closeAmount,
      'receiver': instance.receiver,
    };
