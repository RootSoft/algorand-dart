import 'package:algorand_dart/algorand_dart.dart';

class ApplicationClearStateTransactionBuilder
    extends ApplicationBaseTransactionBuilder {
  ApplicationClearStateTransactionBuilder([
    OnCompletion onCompletion = OnCompletion.CLEAR_STATE_OC,
  ]) : super(onCompletion);

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
