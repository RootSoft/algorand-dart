import 'dart:typed_data';

import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/transaction_builders.dart';
import 'package:algorand_dart/src/utils/serializers/serializers.dart';
import 'package:algorand_dart/src/utils/transformers/address_transformer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_freeze_transaction.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AssetFreezeTransaction extends RawTransaction {
  /// The address of the account whose asset is being frozen or unfrozen.
  @JsonKey(name: 'fadd')
  @AddressSerializer()
  final Address? freezeAddress;

  /// The ID of the asset being frozen or unfrozen.
  @JsonKey(name: 'faid')
  final int? assetId;

  /// True to freeze the asset.
  @JsonKey(name: 'afrz')
  final bool? freeze;

  AssetFreezeTransaction({
    this.freezeAddress,
    this.assetId,
    this.freeze,
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

  AssetFreezeTransaction.builder(AssetFreezeTransactionBuilder builder)
      : freezeAddress = builder.freezeTarget,
        assetId = builder.assetId,
        freeze = builder.freeze,
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
    final fields = super.toMessagePack();
    fields['fadd'] = const AddressTransformer().toMessagePack(freezeAddress);
    fields['faid'] = assetId;
    fields['afrz'] = freeze;
    return fields;
  }

  factory AssetFreezeTransaction.fromJson(Map<String, dynamic> json) =>
      _$AssetFreezeTransactionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AssetFreezeTransactionToJson(this);

  @override
  List<Object?> get props => [
        ...super.props,
        assetId,
        freezeAddress,
        assetId,
        freeze,
      ];
}
