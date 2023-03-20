import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/algod/transformers/algod_transformer.dart';

class AssetTransferTransactionTransformer extends AlgodTransformer<
    RawTransaction, AssetTransferTransactionResponse?> {
  const AssetTransferTransactionTransformer();

  @override
  AssetTransferTransactionResponse? transform(RawTransaction input) {
    if (input is! AssetTransferTransaction) {
      return null;
    }

    return AssetTransferTransactionResponse(
      amount: input.amount ?? BigInt.zero,
      assetId: input.assetId ?? 0,
      receiver: input.receiver?.encodedAddress ?? '',
      closeAmount: BigInt.zero,
      closeTo: input.closeTo?.encodedAddress,
      sender: input.assetSender?.encodedAddress,
    );
  }
}
