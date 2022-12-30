import 'package:algorand_dart/algorand_dart.dart';

class ApplicationCreateTransactionBuilder
    extends ApplicationUpdateTransactionBuilder {
  /// Holds the maximum number of local state values defined within a
  /// StateSchema object.
  StateSchema? localStateSchema;

  /// Holds the maximum number of global state values defined within a
  /// StateSchema object.
  StateSchema? globalStateSchema;

  /// Number of additional pages allocated to the application's approval and
  /// clear state programs. Each ExtraProgramPages is 2048 bytes.
  ///
  /// The sum of ApprovalProgram and ClearStateProgram may not exceed
  /// 2048*(1+ExtraProgramPages) bytes.
  int _extraPages = 0;

  ApplicationCreateTransactionBuilder([
    OnCompletion onCompletion = OnCompletion.NO_OP_OC,
  ]) : super(onCompletion);

  @override
  set applicationId(int value) {
    if (value != 0) {
      throw AlgorandException(
        message:
            // ignore: lines_longer_than_80_chars
            'Application ID must be zero, do not set this for application create.',
      );
    }
    super.applicationId = value;
  }

  /// When creating an application, you have the option of opting in with the
  /// same transaction. Without this flag a separate transaction is needed to
  /// opt-in.
  set optIn(bool optIn) {
    if (optIn) {
      onCompletion = OnCompletion.OPT_IN_OC;
    } else {
      onCompletion = OnCompletion.NO_OP_OC;
    }
  }

  /// Get the number of additional pages allocated to the application's
  /// approval and clear state programs. Each ExtraProgramPages is 2048 bytes.
  int get extraPages => _extraPages;

  /// Sets the number of additional pages allocated to the application's
  /// approval and clear state programs. Each ExtraProgramPages is 2048 bytes.
  set extraPages(int value) {
    if (value < 0 || value > 3) {
      throw AlgorandException(
        message: 'extraPages must be an integer between 0 and 3 inclusive',
      );
    }

    _extraPages = value;
  }

  @override
  Future<int> estimatedTransactionSize() async {
    return await FeeCalculator.estimateTransactionSize(
      ApplicationCreateTransaction.builder(this),
    );
  }

  @override
  Future<ApplicationCreateTransaction> build() async {
    await super.build();

    return ApplicationCreateTransaction.builder(this);
  }
}
