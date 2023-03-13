import 'package:algorand_dart/algorand_dart.dart';

class ApplicationUpdateTransactionBuilder
    extends ApplicationBaseTransactionBuilder {
  /// Logic executed for every application transaction, except when
  /// on-completion is set to "clear".
  /// It can read and write global state for the application, as well as
  /// account-specific local state. Approval programs may reject the
  /// transaction.
  TEALProgram? approvalProgram;

  /// Logic executed for application transactions with on-completion set to
  /// "clear". It can read and write global state for the application,
  /// as well as  account-specific local state. Clear state programs cannot
  /// reject the transaction.
  TEALProgram? clearStateProgram;

  ApplicationUpdateTransactionBuilder([
    OnCompletion onCompletion = OnCompletion.UPDATE_APPLICATION_OC,
  ]) : super(onCompletion);

  @override
  Future<int> estimatedTransactionSize() async {
    return await FeeCalculator.estimateTransactionSize(
      ApplicationUpdateTransaction.builder(this),
    );
  }

  @override
  Future<ApplicationUpdateTransaction> build() async {
    await super.build();

    return ApplicationUpdateTransaction.builder(this);
  }
}
