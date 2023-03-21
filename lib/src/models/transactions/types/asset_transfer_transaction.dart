import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/utils/transformers/address_transformer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_transfer_transaction.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class AssetTransferTransaction extends RawTransaction {
  /// The unique ID of the asset to be transferred.
  @JsonKey(name: 'xaid')
  final int? assetId;

  /// The amount of the asset to be transferred.
  /// A zero amount transferred to self allocates that asset in the account's
  /// Asset map.
  @JsonKey(name: 'aamt')
  @NullableBigIntSerializer()
  final BigInt? amount;

  /// The sender of the transfer.
  /// The regular sender field should be used and this one set to the zero value
  /// for regular transfers between accounts.
  ///
  /// If this value is nonzero, it indicates a clawback transaction where the
  /// sender is the asset's clawback address and the asset sender is the address
  /// from which the funds will be withdrawn.
  @JsonKey(name: 'asnd')
  @AddressSerializer()
  final Address? assetSender;

  /// The recipient of the asset transfer.
  @JsonKey(name: 'arcv')
  @AddressSerializer()
  final Address? receiver;

  /// Specify this field to remove the asset holding from the sender account
  /// and reduce the account's minimum balance.
  @JsonKey(name: 'aclose')
  @AddressSerializer()
  final Address? closeTo;

  AssetTransferTransaction({
    this.assetId,
    this.amount,
    this.assetSender,
    this.receiver,
    this.closeTo,
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

  AssetTransferTransaction.builder(AssetTransferTransactionBuilder builder)
      : assetId = builder.assetId,
        amount = builder.amount,
        assetSender = builder.assetSender,
        receiver = builder.receiver,
        closeTo = builder.closeTo,
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
    fields['xaid'] = assetId;
    fields['aamt'] = amount;
    fields['asnd'] = const AddressTransformer().toMessagePack(assetSender);
    fields['arcv'] = const AddressTransformer().toMessagePack(receiver);
    fields['aclose'] = const AddressTransformer().toMessagePack(closeTo);
    return fields;
  }

  factory AssetTransferTransaction.fromJson(Map<String, dynamic> json) =>
      _$AssetTransferTransactionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AssetTransferTransactionToJson(this);

  @override
  List<Object?> get props => [
        ...super.props,
        assetId,
        amount,
        assetSender,
        receiver,
        closeTo,
      ];
}
