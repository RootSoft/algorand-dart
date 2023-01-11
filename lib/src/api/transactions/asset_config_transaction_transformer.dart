import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/algod_transformer.dart';
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
        decimals: input.decimals ?? 0,
        creator: '',
        total: BigInt.from(input.total ?? 0),
        clawback: input.clawbackAddress?.encodedAddress,
        defaultFrozen: input.defaultFrozen,
        freeze: input.freezeAddress?.encodedAddress,
        manager: input.managerAddress?.encodedAddress,
        name: input.assetName,
        nameB64: '',
        reserve: input.reserveAddress?.encodedAddress,
        unitName: input.unitName,
        unitNameB64: '',
        url: input.url,
        urlB64: '',
        metadataHash: const ByteArrayToB64Converter().fromJson(input.metaData),
      ),
    );
  }
}
