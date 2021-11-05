// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_accounts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchAccountsResponse _$SearchAccountsResponseFromJson(
        Map<String, dynamic> json) =>
    SearchAccountsResponse(
      currentRound: json['current-round'] as int,
      nextToken: json['next-token'] as String?,
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map(
                  (e) => AccountInformation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      balances: (json['balances'] as List<dynamic>?)
              ?.map((e) => MiniAssetHolding.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$SearchAccountsResponseToJson(
        SearchAccountsResponse instance) =>
    <String, dynamic>{
      'current-round': instance.currentRound,
      'next-token': instance.nextToken,
      'accounts': instance.accounts,
      'balances': instance.balances,
    };
