import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/raw_transaction_builder.dart';
import 'package:algorand_dart/src/utils/fee_calculator.dart';

class AssetFreezeTransactionBuilder
    extends RawTransactionBuilder<AssetFreezeTransaction> {
  /// The address of the account whose asset is being frozen or unfrozen.
  Address? freezeTarget;

  /// The ID of the asset being frozen or unfrozen.
  int? assetId;

  /// True to freeze the asset.
  bool? freeze;

  AssetFreezeTransactionBuilder() : super(TransactionType.ASSET_FREEZE);

  @override
  Future<int> estimatedTransactionSize() async {
    return await FeeCalculator.estimateTransactionSize(
      AssetFreezeTransaction.builder(this),
    );
  }

  @override
  Future<AssetFreezeTransaction> build() async {
    await super.build();

    return AssetFreezeTransaction.builder(this);
  }
}
