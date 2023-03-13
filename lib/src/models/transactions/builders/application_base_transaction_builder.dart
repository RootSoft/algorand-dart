import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';

class ApplicationBaseTransactionBuilder<T extends ApplicationBaseTransaction>
    extends RawTransactionBuilder<ApplicationBaseTransaction> {
  /// ApplicationID is the application being interacted with,
  /// or 0 if creating a new application.
  int _applicationId = 0;

  /// Defines what additional actions occur with the transaction.
  /// See the OnComplete section of the TEAL spec for details.
  OnCompletion onCompletion;

  /// Transaction specific arguments accessed from the application's
  /// approval-program and clear-state-program.
  List<Uint8List>? arguments;

  /// List of accounts in addition to the sender that may be accessed from the
  /// application's approval-program and clear-state-program.
  List<Address>? accounts;

  /// Lists the applications in addition to the application-id whose global
  /// states may be accessed by this application's approval-program and
  /// clear-state-program. The access is read-only.
  List<int>? foreignApps;

  /// Lists the assets whose AssetParams may be accessed by this application's
  /// approval-program and clear-state-program. The access is read-only.
  List<int>? foreignAssets;

  /// The boxes that should be made available for the runtime of the program.
  List<AppBoxReference>? appBoxReferences;

  ApplicationBaseTransactionBuilder([this.onCompletion = OnCompletion.NO_OP_OC])
      : super(TransactionType.APPLICATION_CALL);

  /// Get the id of the application being interacted with,
  /// or 0 if creating a new application.
  int get applicationId => _applicationId;

  set applicationId(int value) {
    if (value < 0) {
      throw AlgorandException(
        message: 'Application id can\'t be smaller than 0.',
      );
    }
    _applicationId = value;
  }

  @override
  Future<int> estimatedTransactionSize() async {
    return await FeeCalculator.estimateTransactionSize(
      ApplicationBaseTransaction.builder(this),
    );
  }

  @override
  Future<ApplicationBaseTransaction> build() async {
    await super.build();

    return ApplicationBaseTransaction.builder(this);
  }
}
