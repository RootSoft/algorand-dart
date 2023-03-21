import 'dart:typed_data';

import 'package:algorand_dart/src/api/api.dart';
import 'package:algorand_dart/src/api/converters/converters.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/utils/serializers/serializers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'application_transaction.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class ApplicationTransaction extends RawTransaction {
  /// Holds the maximum number of global state values defined within a
  /// StateSchema object.
  @JsonKey(name: 'apgs')
  final StateSchema? globalStateSchema;

  /// Holds the maximum number of local state values defined within a
  /// StateSchema object.
  @JsonKey(name: 'apls')
  final StateSchema? localStateSchema;

  /// Number of additional pages allocated to the application's approval and
  /// clear state programs. Each ExtraProgramPages is 2048 bytes.
  ///
  /// The sum of ApprovalProgram and ClearStateProgram may not exceed
  /// 2048*(1+ExtraProgramPages) bytes.
  @JsonKey(name: 'apep')
  final int? extraPages;

  /// Logic executed for every application transaction, except when
  /// on-completion is set to "clear".
  /// It can read and write global state for the application, as well as
  /// account-specific local state. Approval programs may reject the
  /// transaction.
  @JsonKey(name: 'apap')
  @TealProgramConverter()
  final TEALProgram? approvalProgram;

  /// Logic executed for application transactions with on-completion set to
  /// "clear". It can read and write global state for the application,
  /// as well as  account-specific local state. Clear state programs cannot
  /// reject the transaction.
  @JsonKey(name: 'apsu')
  @TealProgramConverter()
  final TEALProgram? clearStateProgram;

  /// ApplicationID is the application being interacted with,
  /// or 0 if creating a new application.
  @JsonKey(name: 'apid', defaultValue: 0)
  final int applicationId;

  /// Defines what additional actions occur with the transaction.
  /// See the OnComplete section of the TEAL spec for details.
  @JsonKey(name: 'apan')
  @OnCompletionConverter()
  final OnCompletion? onCompletion;

  /// Transaction specific arguments accessed from the application's
  /// approval-program and clear-state-program.
  @JsonKey(name: 'apaa')
  @ListByteArraySerializer()
  final List<Uint8List>? arguments;

  /// List of accounts in addition to the sender that may be accessed from the
  /// application's approval-program and clear-state-program.
  @JsonKey(name: 'apat')
  @ListByteArraySerializer()
  final List<Uint8List>? accounts;

  /// Lists the applications in addition to the application-id whose global
  /// states may be accessed by this application's approval-program and
  /// clear-state-program. The access is read-only.
  @JsonKey(name: 'apfa', defaultValue: [])
  final List<int> foreignApps;

  /// Lists the assets whose AssetParams may be accessed by this application's
  /// approval-program and clear-state-program. The access is read-only.
  @JsonKey(name: 'apas', defaultValue: [])
  final List<int> foreignAssets;

  /// The boxes that should be made available for the runtime of the program.
  @JsonKey(name: 'apbx', defaultValue: [])
  final List<BoxReference> boxes;

  ApplicationTransaction({
    required this.globalStateSchema,
    required this.localStateSchema,
    required this.extraPages,
    required this.approvalProgram,
    required this.clearStateProgram,
    required this.applicationId,
    required this.onCompletion,
    required this.arguments,
    required this.accounts,
    required this.foreignApps,
    required this.foreignAssets,
    required this.boxes,
    BigInt? fee,
    BigInt? firstValid,
    Uint8List? genesisHash,
    BigInt? lastValid,
    Address? sender,
    String? type,
    String? genesisId,
    Uint8List? group,
    Uint8List? lease,
    Uint8List? note,
    Address? rekeyTo,
  }) : super(
          type: type,
          fee: fee,
          firstValid: firstValid,
          genesisHash: genesisHash,
          lastValid: lastValid,
          sender: sender,
          genesisId: genesisId,
          group: group,
          lease: lease,
          note: note,
          rekeyTo: rekeyTo,
        );

  @override
  Map<String, dynamic> toMessagePack() {
    final fields = super.toMessagePack();
    fields['apid'] = applicationId;
    fields['apan'] = onCompletion?.value;
    fields['apaa'] = arguments;
    fields['apat'] = accounts;
    fields['apfa'] = foreignApps;
    fields['apas'] = foreignAssets;
    fields['apbx'] = boxes.map((b) => b.toMessagePack()).toList();
    fields['apls'] = localStateSchema?.toMessagePack();
    fields['apgs'] = globalStateSchema?.toMessagePack();
    fields['apep'] = extraPages;
    fields['apap'] = approvalProgram?.program;
    fields['apsu'] = clearStateProgram?.program;

    return fields;
  }

  factory ApplicationTransaction.fromJson(Map<String, dynamic> json) =>
      _$ApplicationTransactionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ApplicationTransactionToJson(this);

  @override
  List<Object?> get props => [
        ...super.props,
        globalStateSchema,
        localStateSchema,
        extraPages,
        approvalProgram,
        clearStateProgram,
        applicationId,
        onCompletion,
        arguments,
        accounts,
        foreignApps,
        foreignAssets,
        boxes,
      ];
}
