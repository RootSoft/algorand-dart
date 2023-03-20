import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/raw_transaction_builder.dart';
import 'package:algorand_dart/src/utils/fee_calculator.dart';

class AssetTransferTransactionBuilder
    extends RawTransactionBuilder<AssetTransferTransaction> {
  /// For re-configure or destroy transactions, this is the unique asset ID.
  /// On asset creation, the ID is set to zero.
  int? assetId;

  /// The amount of the asset to be transferred.
  /// A zero amount transferred to self allocates that asset in the account's
  /// Asset map.
  BigInt? amount;

  /// The sender of the transfer.
  /// The regular sender field should be used and this one set to the zero value
  /// for regular transfers between accounts.
  ///
  /// If this value is nonzero, it indicates a clawback transaction where the
  /// sender is the asset's clawback address and the asset sender is the address
  /// from which the funds will be withdrawn.
  Address? assetSender;

  /// The recipient of the asset transfer.
  Address? receiver;

  /// Specify this field to remove the asset holding from the sender account
  /// and reduce the account's minimum balance.
  Address? closeTo;

  AssetTransferTransactionBuilder() : super(TransactionType.ASSET_TRANSFER);

  @override
  Future<int> estimatedTransactionSize() async {
    return await FeeCalculator.estimateTransactionSize(
      AssetTransferTransaction.builder(this),
    );
  }

  @override
  Future<AssetTransferTransaction> build() async {
    await super.build();

    return AssetTransferTransaction.builder(this);
  }
}
