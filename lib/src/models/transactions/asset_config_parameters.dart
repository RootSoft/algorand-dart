import 'dart:typed_data';

import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/utils/message_packable.dart';
import 'package:algorand_dart/src/utils/serializers/serializers.dart';
import 'package:algorand_dart/src/utils/transformers/address_transformer.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_config_parameters.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AssetConfigParameters extends Equatable implements MessagePackable {
  /// The total number of base units of the asset to create.
  /// This number cannot be changed.
  /// Required on creation.
  @JsonKey(name: 't')
  @NullableBigIntSerializer()
  final BigInt? total;

  /// The number of digits to use after the decimal point when
  /// displaying the asset.
  ///
  /// If 0, the asset is not divisible.
  /// If 1, the base unit of the asset is in tenths.
  /// If 2, the base unit of the asset is in hundredths.
  /// Required on creation.
  @JsonKey(name: 'dc', defaultValue: 0)
  final int? decimals;

  /// True to freeze holdings for this asset by default.
  @JsonKey(name: 'df')
  final bool? defaultFrozen;

  /// The name of a unit of this asset. Supplied on creation. Example: USDT
  @JsonKey(name: 'un')
  final String? unitName;

  /// The name of the asset. Supplied on creation. Example: Tether
  @JsonKey(name: 'an')
  final String? assetName;

  /// Specifies a URL where more information about the asset can be retrieved.
  /// Max size is 32 bytes.
  @JsonKey(name: 'au')
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
  @JsonKey(name: 'am')
  @Base64Serializer()
  final Uint8List? metaData;

  /// The address of the account that can manage the configuration of the asset
  /// and destroy it.
  @JsonKey(name: 'm')
  @AddressSerializer()
  final Address? managerAddress;

  /// The address of the account that holds the reserve (non-minted) units of
  /// the asset.
  ///
  /// This address has no specific authority in the protocol itself.
  /// It is used in the case where you want to signal to holders of your asset
  /// that the non-minted units of the asset reside in an account that is
  /// different from the default creator account (the sender).
  @JsonKey(name: 'r')
  @AddressSerializer()
  final Address? reserveAddress;

  /// The address of the account used to freeze holdings of this asset.
  ///
  /// If empty, freezing is not permitted.
  @JsonKey(name: 'f')
  @AddressSerializer()
  final Address? freezeAddress;

  /// The address of the account that can clawback holdings of this asset.
  /// If empty, clawback is not permitted.
  @JsonKey(name: 'c')
  @AddressSerializer()
  final Address? clawbackAddress;

  AssetConfigParameters({
    this.total,
    this.decimals,
    this.defaultFrozen,
    this.unitName,
    this.assetName,
    this.url,
    this.metaData,
    this.managerAddress,
    this.reserveAddress,
    this.freezeAddress,
    this.clawbackAddress,
  });

  factory AssetConfigParameters.fromJson(Map<String, dynamic> json) =>
      _$AssetConfigParametersFromJson(json);

  Map<String, dynamic> toJson() => _$AssetConfigParametersToJson(this);

  @override
  Map<String, dynamic> toMessagePack() {
    return {
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
  }

  @override
  List<Object?> get props => [
        total,
        decimals,
        defaultFrozen,
        unitName,
        assetName,
        url,
        metaData,
        managerAddress,
        reserveAddress,
        freezeAddress,
        clawbackAddress,
      ];
}
