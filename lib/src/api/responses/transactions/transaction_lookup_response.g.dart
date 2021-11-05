// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_lookup_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    TransactionResponse(
      currentRound: json['current-round'] as int,
      transaction:
          Transaction.fromJson(json['transaction'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionResponseToJson(
        TransactionResponse instance) =>
    <String, dynamic>{
      'current-round': instance.currentRound,
      'transaction': instance.transaction,
    };
