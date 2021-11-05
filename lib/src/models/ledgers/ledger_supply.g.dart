// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_supply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LedgerSupply _$LedgerSupplyFromJson(Map<String, dynamic> json) => LedgerSupply(
      currentRound: json['current_round'] as int,
      onlineMoney: json['online-money'] as int,
      totalMoney: json['total-money'] as int,
    );

Map<String, dynamic> _$LedgerSupplyToJson(LedgerSupply instance) =>
    <String, dynamic>{
      'current_round': instance.currentRound,
      'online-money': instance.onlineMoney,
      'total-money': instance.totalMoney,
    };
