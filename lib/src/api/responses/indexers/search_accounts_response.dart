import 'package:algorand_dart/algorand_dart.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_accounts_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class SearchAccountsResponse {
  final int currentRound;
  final String? nextToken;
  @JsonKey(name: 'accounts', defaultValue: <AccountInformation>[])
  final List<AccountInformation> accounts;
  @JsonKey(name: 'balances', defaultValue: <MiniAssetHolding>[])
  final List<MiniAssetHolding> balances;

  SearchAccountsResponse({
    required this.currentRound,
    this.nextToken,
    required this.accounts,
    required this.balances,
  });

  factory SearchAccountsResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchAccountsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchAccountsResponseToJson(this);
}
