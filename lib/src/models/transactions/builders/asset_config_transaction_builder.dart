import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/raw_transaction_builder.dart';
import 'package:algorand_dart/src/utils/fee_calculator.dart';

class AssetConfigTransactionBuilder
    extends RawTransactionBuilder<AssetConfigTransaction> {
  /// For re-configure or destroy transactions, this is the unique asset ID.
  /// On asset creation, the ID is set to zero.
  int? assetId;

  /// The total number of base units of the asset to create.
  /// This number cannot be changed. Required on creation.
  BigInt? totalAssetsToCreate;

  /// The number of digits to use after the decimal point when displaying
  /// the asset.
  ///
  /// If 0, the asset is not divisible.
  /// If 1, the base unit of the asset is in tenths.
  /// If 2, the base unit of the asset is in hundredths.
  /// Required on creation.
  int? decimals;

  /// True to freeze holdings for this asset by default.
  bool? defaultFrozen;

  /// The name of a unit of this asset. Supplied on creation. Example: USDT
  String? unitName;

  /// The name of the asset. Supplied on creation. Example: Tether
  String? assetName;

  /// Specifies a URL where more information about the asset can be retrieved.
  /// Max size is 32 bytes.
  String? url;

  /// This field is intended to be a 32-byte hash of some metadata that is
  /// relevant to your asset and/or asset holders.
  ///
  /// The format of this metadata is up to the application.
  /// This field can only be specified upon creation.
  ///
  /// An example might be the hash of some certificate that acknowledges the
  /// digitized asset as the official representation of a particular real-world
  /// asset.
  Uint8List? metaData;

  /// The address of the account that can manage the configuration of the asset
  /// and destroy it.
  Address? managerAddress;

  /// The address of the account that holds the reserve (non-minted) units of
  /// the asset.
  ///
  /// This address has no specific authority in the protocol itself.
  /// It is used in the case where you want to signal to holders of your asset
  /// that the non-minted units of the asset reside in an account that is
  /// different from the default creator account (the sender).
  Address? reserveAddress;

  /// The address of the account used to freeze holdings of this asset.
  ///
  /// If empty, freezing is not permitted.
  Address? freezeAddress;

  /// The address of the account that can clawback holdings of this asset.
  /// If empty, clawback is not permitted.
  Address? clawbackAddress;

  /// Boolean to destroy the asset.
  /// use in combination with the asset id.
  bool destroy = false;

  AssetConfigTransactionBuilder() : super(TransactionType.ASSET_CONFIG);

  set metadataText(String data) {
    metaData = Uint8List.fromList(utf8.encode(data));
  }

  set metadataB64(String data) {
    metaData = base64Decode(data);
  }

  AssetConfigParameters get params => AssetConfigParameters(
        total: totalAssetsToCreate,
        decimals: decimals,
        defaultFrozen: defaultFrozen,
        unitName: unitName,
        assetName: assetName,
        url: url,
        metaData: metaData,
        managerAddress: managerAddress,
        reserveAddress: reserveAddress,
        freezeAddress: freezeAddress,
        clawbackAddress: clawbackAddress,
      );

  @override
  Future<int> estimatedTransactionSize() async {
    return await FeeCalculator.estimateTransactionSize(
      AssetConfigTransaction.builder(this),
    );
  }

  @override
  Future<AssetConfigTransaction> build() async {
    await super.build();

    return AssetConfigTransaction.builder(this);
  }
}
