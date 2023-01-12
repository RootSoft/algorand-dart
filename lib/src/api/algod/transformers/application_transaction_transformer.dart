import 'dart:convert';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/algod/transformers/algod_transformer.dart';
import 'package:algorand_dart/src/api/converters/byte_array_to_b64_converter.dart';

class ApplicationTransactionTransformer
    extends AlgodTransformer<RawTransaction, ApplicationTransactionResponse?> {
  const ApplicationTransactionTransformer();

  @override
  ApplicationTransactionResponse? transform(RawTransaction input) {
    if (input is! ApplicationTransaction) {
      return null;
    }

    return ApplicationTransactionResponse(
      applicationId: input.applicationId,
      onCompletion: input.onCompletion ?? OnCompletion.NO_OP_OC,
      accounts: input.accounts
              ?.map((e) => Address(publicKey: e).encodedAddress)
              .toList() ??
          [],
      applicationArguments:
          input.arguments?.map((e) => base64.encode(e)).toList() ?? [],
      foreignApps: input.foreignApps,
      foreignAssets: input.foreignAssets,
      extraProgramPages: input.extraPages ?? 0,
      approvalProgram: const ByteArrayToB64Converter()
          .fromJson(input.approvalProgram?.program),
      clearStateProgram: const ByteArrayToB64Converter()
          .fromJson(input.clearStateProgram?.program),
      globalStateSchema: input.globalStateSchema,
      localStateSchema: input.localStateSchema,
    );
  }
}
