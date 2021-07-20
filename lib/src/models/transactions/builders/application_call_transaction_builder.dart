import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/application_base_transaction_builder.dart';
import 'package:algorand_dart/src/utils/fee_calculator.dart';

class ApplicationCallTransactionBuilder
    extends ApplicationBaseTransactionBuilder {
  ApplicationCallTransactionBuilder([
    OnCompletion onCompletion = OnCompletion.NO_OP_OC,
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
