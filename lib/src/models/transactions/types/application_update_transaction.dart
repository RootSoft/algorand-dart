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
