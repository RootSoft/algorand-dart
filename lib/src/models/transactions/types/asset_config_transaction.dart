import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/transaction_builders.dart';
import 'package:algorand_dart/src/utils/transformers/address_transformer.dart';

class AssetConfigTransaction extends RawTransaction {
  /// For re-configure or destroy transactions, this is the unique asset ID.
  /// On asset creation, the ID is set to zero.
  final int? assetId;

  /// The total number of base units of the asset to create.
  /// This number cannot be changed.
  /// Required on creation.
  final int? total;

  /// The number of digits to use after the decimal point when
  /// displaying the asset.
  ///
  /// If 0, the asset is not divisible.
  /// If 1, the base unit of the asset is in tenths.
  /// If 2, the base unit of the asset is in hundredths.
  /// Required on creation.
  final int? decimals;

  /// True to freeze holdings for this asset by default.
  final bool? defaultFrozen;

  /// The name of a unit of this asset. Supplied on creation. Example: USDT
  final String? unitName;

  /// The name of the asset. Supplied on creation. Example: Tether
  final String? assetName;

  /// Specifies a URL where more information about the asset can be retrieved.
  /// Max size is 32 bytes.
  final String? url;

  /// This field is intended to be a 32-byte hash of some metadata that is
  /// relevant to your asset and/or asset holders.
  ///
  /// The format of this metadata is up to the application.
  /// This field can only be specified upon creation.
  ///
  /// An example might be the hash of some certificate that acknowledges the
  /// digitized asset as the official representation of a particular real-world
  /// asset.
  final String? metaData;

  /// The address of the account that can manage the configuration of the asset
  /// and destroy it.
  @AddressTransformer()
  final Address? managerAddress;

  /// The address of the account that holds the reserve (non-minted) units of
  /// the asset.
  ///
  /// This address has no specific authority in the protocol itself.
  /// It is used in the case where you want to signal to holders of your asset
  /// that the non-minted units of the asset reside in an account that is
  /// different from the default creator account (the sender).
  @AddressTransformer()
  final Address? reserveAddress;

  /// The address of the account used to freeze holdings of this asset.
  ///
  /// If empty, freezing is not permitted.
  @AddressTransformer()
  final Address? freezeAddress;

  /// The address of the account that can clawback holdings of this asset.
  /// If empty, clawback is not permitted.
  @AddressTransformer()
  final Address? clawbackAddress;

  /// Boolean to destroy the asset.
  /// use in combination with the asset id.
  final bool destroy;

  AssetConfigTransaction.builder(AssetConfigTransactionBuilder builder)
      : assetId = builder.assetId,
        total = builder.totalAssetsToCreate,
        decimals = builder.decimals,
        defaultFrozen = builder.defaultFrozen,
        unitName = builder.unitName,
        assetName = builder.assetName,
        url = builder.url,
        metaData = builder.metaData,
        managerAddress = builder.managerAddress,
        reserveAddress = builder.reserveAddress,
        freezeAddress = builder.freezeAddress,
        clawbackAddress = builder.clawbackAddress,
        destroy = builder.destroy,
        super(
          type: builder.type.value,
          fee: builder.fee,
          firstValid: builder.firstValid,
          genesisHash: builder.genesisHash,
          lastValid: builder.lastValid,
          sender: builder.sender,
          genesisId: builder.genesisId,
          group: builder.group,
          lease: builder.lease,
          note: builder.note,
          rekeyTo: builder.rekeyTo,
        );

  @override
  Map<String, dynamic> toMessagePack() {
    final transactionFields = super.toMessagePack();

    // Add the asset id (not for creation)
    transactionFields['caid'] = assetId;

    // Add the asset paramets
    transactionFields['apar'] = {
      't': total,
      'dc': decimals,
      'df': defaultFrozen,
      'un': unitName,
      'an': assetName,
      'au': url,
      'am': metaData,
      'm': const AddressTransformer().toMessagePack(managerAddress),
      'r': const AddressTransformer().toMessagePack(reserveAddress),
      'f': const AddressTransformer().toMessagePack(freezeAddress),
      'c': const AddressTransformer().toMessagePack(clawbackAddress),
    };

    // Should the asset be destroyed?
    if (destroy == true) {
      transactionFields.remove('apar');
    }

    return transactionFields;
  }
}
