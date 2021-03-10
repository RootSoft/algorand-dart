import 'package:json_annotation/json_annotation.dart';

part 'ledger_supply.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class LedgerSupply {
  @JsonKey(name: 'current_round')
  final int currentRound;
  final int onlineMoney;
  final int totalMoney;

  LedgerSupply({
    required this.currentRound,
    required this.onlineMoney,
    required this.totalMoney,
  });

  factory LedgerSupply.fromJson(Map<String, dynamic> json) =>
      _$LedgerSupplyFromJson(json);

  Map<String, dynamic> toJson() => _$LedgerSupplyToJson(this);
}
