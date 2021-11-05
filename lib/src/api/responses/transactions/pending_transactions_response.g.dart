// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_transactions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingTransactionsResponse _$PendingTransactionsResponseFromJson(
        Map<String, dynamic> json) =>
    PendingTransactionsResponse(
      transactions: (json['top-transactions'] as List<dynamic>)
          .map((e) => SignedTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalTransactions: json['total-transactions'] as int,
    );

Map<String, dynamic> _$PendingTransactionsResponseToJson(
        PendingTransactionsResponse instance) =>
    <String, dynamic>{
      'top-transactions': instance.transactions,
      'total-transactions': instance.totalTransactions,
    };
