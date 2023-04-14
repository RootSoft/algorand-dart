import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/algod/transformers/algod_transformer.dart';
import 'package:algorand_dart/src/api/converters/byte_array_to_b64_converter.dart';

class AssetConfigTransactionTransformer
    extends AlgodTransformer<RawTransaction, AssetConfigTransactionResponse?> {
  const AssetConfigTransactionTransformer();

  @override
  AssetConfigTransactionResponse? transform(RawTransaction input) {
    if (input is! AssetConfigTransaction) {
      return null;
    }

    return AssetConfigTransactionResponse(
      assetId: input.assetId,
      parameters: AssetParameters(
        decimals: input.params?.decimals ?? 0,
        creator: '',
        total: input.params?.total ?? BigInt.zero,
        clawback: input.params?.clawbackAddress?.encodedAddress,
        defaultFrozen: input.params?.defaultFrozen,
        freeze: input.params?.freezeAddress?.encodedAddress,
        manager: input.params?.managerAddress?.encodedAddress,
        name: input.params?.assetName,
        nameB64: '',
        reserve: input.params?.reserveAddress?.encodedAddress,
        unitName: input.params?.unitName,
        unitNameB64: '',
        url: input.params?.url,
        urlB64: '',
        metadataHash:
            const ByteArrayToB64Converter().fromJson(input.params?.metaData),
      ),
    );
  }
}
