import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/transaction_builders.dart';
import 'package:algorand_dart/src/utils/transformers/address_transformer.dart';

class AssetFreezeTransaction extends RawTransaction {
  /// The address of the account whose asset is being frozen or unfrozen.
  final Address? freezeAddress;

  /// The ID of the asset being frozen or unfrozen.
  final int? assetId;

  /// True to freeze the asset.
  final bool? freeze;

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
}
