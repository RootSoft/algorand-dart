import 'package:json_annotation/json_annotation.dart';

part 'asset_parameters_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AssetParameters {
  /// The total number of units of this asset.
  final int total;

  /// The number of digits to use after the decimal point when displaying
  /// this asset.
  ///
  /// If 0, the asset is not divisible.
  /// If 1, the base unit of the asset is in tenths.
  /// If 2, the base unit of the asset is in hundredths, and so on.
  ///
  /// This value must be between 0 and 19 (inclusive).
  /// Minimum value : 0
  /// Maximum value : 19
  final int decimals;

  /// The address that created this asset.
  ///
  /// This is the address where the parameters for this asset can be found,
  /// and also the address where unwanted asset units can be sent in the
  /// worst case.
  final String creator;

  /// Address of account used to clawback holdings of this asset.
  ///
  /// If empty, clawback is not permitted.
  final String? clawback;

  /// Whether holdings of this asset are frozen by default.
  final bool? defaultFrozen;

  /// Address of account used to freeze holdings of this asset.
  ///
  /// If empty, freezing is not permitted.
  final String? freeze;

  /// Address of account used to manage the keys of this asset and to
  /// destroy it.
  final String? manager;

  /// Name of this asset, as supplied by the creator.
  final String? name;

  /// Address of account holding reserve (non-minted) units of this asset.
  final String? reserve;

  /// Name of a unit of this asset, as supplied by the creator.
  final String? unitName;

  /// URL where more information about the asset can be retrieved.
  final String? url;

  /// A commitment to some unspecified asset metadata.
  /// The format of this metadata is up to the application.
  final String? metadataHash;

  AssetParameters({
    required this.decimals,
    required this.creator,
    required this.total,
    this.clawback,
    this.defaultFrozen,
    this.freeze,
    this.manager,
    this.name,
    this.reserve,
    this.unitName,
    this.url,
    this.metadataHash,
  });

  factory AssetParameters.fromJson(Map<String, dynamic> json) =>
      _$AssetParametersFromJson(json);

  Map<String, dynamic> toJson() => _$AssetParametersToJson(this);

  @override
  String toString() {
    return 'AssetParameters{'
        'total: $total, '
        'decimals: $decimals, '
        'creator: $creator, '
        'clawback: $clawback, '
        'defaultFrozen: $defaultFrozen, '
        'freeze: $freeze, '
        'manager: $manager, '
        'name: $name, '
        'reserve: $reserve, '
        'unitName: $unitName, '
        'url: $url, '
        'metadataHash: $metadataHash'
        '}';
  }
}
