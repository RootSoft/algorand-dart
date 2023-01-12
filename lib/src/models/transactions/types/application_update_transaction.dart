import 'dart:typed_data';

import 'package:algorand_dart/src/api/application/application.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/transaction_builders.dart';

class ApplicationUpdateTransaction extends ApplicationBaseTransaction {
  /// Logic executed for every application transaction, except when
  /// on-completion is set to "clear".
  /// It can read and write global state for the application, as well as
  /// account-specific local state. Approval programs may reject the
  /// transaction.
  final TEALProgram? approvalProgram;

  /// Logic executed for application transactions with on-completion set to
  /// "clear". It can read and write global state for the application,
  /// as well as  account-specific local state. Clear state programs cannot
  /// reject the transaction.
  final TEALProgram? clearStateProgram;

  ApplicationUpdateTransaction({
    required this.approvalProgram,
    required this.clearStateProgram,
    int? fee,
    int? firstValid,
    Uint8List? genesisHash,
    int? lastValid,
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

  ApplicationUpdateTransaction.builder(
    ApplicationUpdateTransactionBuilder builder,
  )   : approvalProgram = builder.approvalProgram,
        clearStateProgram = builder.clearStateProgram,
        super.builder(builder);

  @override
  Map<String, dynamic> toMessagePack() {
    final fields = super.toMessagePack();
    fields['apap'] = approvalProgram?.program;
    fields['apsu'] = clearStateProgram?.program;
    return fields;
  }
}
