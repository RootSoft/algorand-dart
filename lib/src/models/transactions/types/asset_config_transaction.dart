import 'dart:typed_data';

import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/transaction_builders.dart';
import 'package:algorand_dart/src/utils/serializers/serializers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_config_transaction.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class AssetConfigTransaction extends RawTransaction {
  /// For re-configure or destroy transactions, this is the unique asset ID.
  /// On asset creation, the ID is set to zero.
  @JsonKey(name: 'caid')
  final int? assetId;

  /// The total number of base units of the asset to create.
  /// This number cannot be changed.
  /// Required on creation.
  @JsonKey(name: 'apar')
  final AssetConfigParameters? params;

  /// Boolean to destroy the asset.
  /// use in combination with the asset id.
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool destroy;

  AssetConfigTransaction({
    this.assetId,
    this.params,
    this.destroy = false,
    BigInt? fee,
    BigInt? firstValid,
    Uint8List? genesisHash,
    BigInt? lastValid,
    Address? sender,
    String? type,
    String? genesisId,
    Uint8List? group,
    Uint8List? lease,
    Uint8List? note,
    Address? rekeyTo,
  }) : super(
          type: type,
          fee: fee,
          firstValid: firstValid,
          genesisHash: genesisHash,
          lastValid: lastValid,
          sender: sender,
          genesisId: genesisId,
          group: group,
          lease: lease,
          note: note,
          rekeyTo: rekeyTo,
        );

  AssetConfigTransaction.builder(AssetConfigTransactionBuilder builder)
      : assetId = builder.assetId,
        params = builder.params,
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

  factory AssetConfigTransaction.fromJson(Map<String, dynamic> json) =>
      _$AssetConfigTransactionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AssetConfigTransactionToJson(this);

  @override
  Map<String, dynamic> toMessagePack() {
    final transactionFields = super.toMessagePack();

    // Add the asset id (not for creation)
    transactionFields['caid'] = assetId;

    // Add the asset parameters
    transactionFields['apar'] = params?.toMessagePack();

    // Should the asset be destroyed?
    if (destroy == true) {
      transactionFields.remove('apar');
    }

    return transactionFields;
  }

  @override
  List<Object?> get props => [
        ...super.props,
        assetId,
        params,
        destroy,
      ];
}
