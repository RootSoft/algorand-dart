import 'package:algorand_dart/src/api/account/account.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_lookup_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AccountResponse {
  /// Round at which the results were computed.
  final int currentRound;
  final AccountInformation account;

  AccountResponse({required this.currentRound, required this.account});

  factory AccountResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AccountResponseToJson(this);
}
