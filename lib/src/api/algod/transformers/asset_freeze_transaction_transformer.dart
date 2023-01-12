import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/algod/transformers/algod_transformer.dart';

class AssetFreezeTransactionTransformer
    extends AlgodTransformer<RawTransaction, AssetFreezeTransactionResponse?> {
  const AssetFreezeTransactionTransformer();

  @override
  AssetFreezeTransactionResponse? transform(RawTransaction input) {
    if (input is! AssetFreezeTransaction) {
      return null;
    }

    return AssetFreezeTransactionResponse(
      address: input.freezeAddress?.encodedAddress ?? '',
      assetId: input.assetId ?? 0,
      newFreezeStatus: input.freeze ?? false,
    );
  }
}
