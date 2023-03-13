import 'package:algorand_dart/algorand_dart.dart';

class ApplicationOptInTransactionBuilder
    extends ApplicationBaseTransactionBuilder {
  ApplicationOptInTransactionBuilder([
    OnCompletion onCompletion = OnCompletion.OPT_IN_OC,
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
