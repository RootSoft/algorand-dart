// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_lookup_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountResponse _$AccountResponseFromJson(Map<String, dynamic> json) =>
    AccountResponse(
      currentRound: json['current-round'] as int?,
      account: json['account'] != null
          ? AccountInformation.fromJson(json['account'] as Map<String, dynamic>)
          : null,
    );

Map<String, dynamic> _$AccountResponseToJson(AccountResponse instance) =>
    <String, dynamic>{
      'current-round': instance.currentRound,
      'account': instance.account,
    };
