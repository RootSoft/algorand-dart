import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/transaction_builders.dart';
import 'package:algorand_dart/src/utils/transformers/address_transformer.dart';

class AssetTransferTransaction extends RawTransaction {
  /// The unique ID of the asset to be transferred.
  final int? assetId;

  /// The amount of the asset to be transferred.
  /// A zero amount transferred to self allocates that asset in the account's
  /// Asset map.
  final int? amount;

  /// The sender of the transfer.
  /// The regular sender field should be used and this one set to the zero value
  /// for regular transfers between accounts.
  ///
  /// If this value is nonzero, it indicates a clawback transaction where the
  /// sender is the asset's clawback address and the asset sender is the address
  /// from which the funds will be withdrawn.
  final Address? assetSender;

  /// The recipient of the asset transfer.
  final Address? receiver;

  /// Specify this field to remove the asset holding from the sender account
  /// and reduce the account's minimum balance.
  final Address? closeTo;

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
}
