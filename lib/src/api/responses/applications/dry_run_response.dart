import 'package:algorand_dart/src/api/responses.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dry_run_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class DryRunResponse {
  @JsonKey(name: 'error', defaultValue: '')
  final String error;

  @JsonKey(name: 'protocol-version', defaultValue: '')
  final String protocolVersion;

  @JsonKey(name: 'txns', defaultValue: [])
  final List<DryRunTxResult> transactions;

  DryRunResponse({
    required this.error,
    required this.protocolVersion,
    required this.transactions,
  });

  factory DryRunResponse.fromJson(Map<String, dynamic> json) =>
      _$DryRunResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DryRunResponseToJson(this);
}
