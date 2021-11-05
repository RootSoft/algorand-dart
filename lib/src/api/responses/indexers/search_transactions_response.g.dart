// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_transactions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchTransactionsResponse _$SearchTransactionsResponseFromJson(
        Map<String, dynamic> json) =>
    SearchTransactionsResponse(
      currentRound: json['current-round'] as int,
      nextToken: json['next-token'] as String?,
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchTransactionsResponseToJson(
        SearchTransactionsResponse instance) =>
    <String, dynamic>{
      'current-round': instance.currentRound,
      'next-token': instance.nextToken,
      'transactions': instance.transactions,
    };
