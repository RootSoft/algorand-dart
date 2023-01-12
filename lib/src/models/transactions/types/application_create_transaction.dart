import 'package:algorand_dart/src/api/application/application.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/transaction_builders.dart';

class ApplicationCreateTransaction extends ApplicationUpdateTransaction {
  /// Holds the maximum number of local state values defined within a
  /// StateSchema object.
  final StateSchema? localStateSchema;

  /// Holds the maximum number of global state values defined within a
  /// StateSchema object.
  final StateSchema? globalStateSchema;

  /// Number of additional pages allocated to the application's approval and
  /// clear state programs. Each ExtraProgramPages is 2048 bytes.
  ///
  /// The sum of ApprovalProgram and ClearStateProgram may not exceed
  /// 2048*(1+ExtraProgramPages) bytes.
  int? extraPages;

  ApplicationCreateTransaction.builder(
    ApplicationCreateTransactionBuilder builder,
  )   : localStateSchema = builder.localStateSchema,
        globalStateSchema = builder.globalStateSchema,
        extraPages = builder.extraPages,
        super.builder(builder);

  @override
  Map<String, dynamic> toMessagePack() {
    final fields = super.toMessagePack();
    fields['apls'] = localStateSchema?.toMessagePack();
    fields['apgs'] = globalStateSchema?.toMessagePack();
    fields['apep'] = extraPages;
    return fields;
  }
}
