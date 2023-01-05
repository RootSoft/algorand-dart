import 'package:algorand_dart/src/api/application/application.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'application_transaction_response.g.dart';

/// Fields for application transactions.
@JsonSerializable(fieldRename: FieldRename.kebab)
class ApplicationTransactionResponse {
  /// List of accounts in addition to the sender that may be accessed from the
  /// application's approval-program and clear-state-program.
  @JsonKey(name: 'accounts', defaultValue: [])
  final List<String> accounts;

  /// Transaction specific arguments accessed from the application's
  /// approval-program and clear-state-program.
  @JsonKey(name: 'application-args', defaultValue: [])
  final List<String> applicationArguments;

  /// ID of the application being configured or empty if creating.
  @JsonKey(name: 'application-id')
  final int applicationId;

  /// Logic executed for every application transaction, except when
  /// on-completion is set to "clear".
  /// It can read and write global state for the application, as well as
  /// account-specific local state. Approval programs may reject the
  /// transaction.
  @JsonKey(name: 'approval-program')
  final String? approvalProgram;

  /// Logic executed for application transactions with on-completion
  /// set to "clear".
  /// It can read and write global state for the application, as well as
  /// account-specific local state. Clear state programs cannot reject the
  /// transaction.
  @JsonKey(name: 'clear-state-program')
  final String? clearStateProgram;

  /// Specifies the additional app program len requested in pages.
  /// Defaults to 0
  @JsonKey(name: 'extra-program-pages', defaultValue: 0)
  final int extraProgramPages;

  /// Lists the applications in addition to the application-id whose global
  /// states may be accessed by this application's approval-program and
  /// clear-state-program. The access is read-only.
  @JsonKey(name: 'foreign-apps', defaultValue: [])
  final List<int> foreignApps;

  /// Lists the assets whose parameters may be accessed by this application's
  /// ApprovalProgram and ClearStateProgram. The access is read-only.
  @JsonKey(name: 'foreign-assets', defaultValue: [])
  final List<int> foreignAssets;

  @JsonKey(name: 'global-state-schema')
  final StateSchema? globalStateSchema;

  @JsonKey(name: 'local-state-schema')
  final StateSchema? localStateSchema;

  @JsonKey(name: 'on-completion', unknownEnumValue: OnCompletion.NO_OP_OC)
  final OnCompletion onCompletion;

  ApplicationTransactionResponse({
    required this.applicationId,
    required this.onCompletion,
    required this.accounts,
    required this.applicationArguments,
    required this.foreignApps,
    required this.foreignAssets,
    required this.extraProgramPages,
    this.approvalProgram,
    this.clearStateProgram,
    this.globalStateSchema,
    this.localStateSchema,
  });

  factory ApplicationTransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplicationTransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationTransactionResponseToJson(this);
}
