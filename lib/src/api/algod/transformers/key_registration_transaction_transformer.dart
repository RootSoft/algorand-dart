import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/algod/transformers/algod_transformer.dart';

class KeyRegistrationTransactionTransformer extends AlgodTransformer<
    RawTransaction, KeyRegistrationTransactionResponse?> {
  const KeyRegistrationTransactionTransformer();

  @override
  KeyRegistrationTransactionResponse? transform(RawTransaction input) {
    if (input is! KeyRegistrationTransaction) {
      return null;
    }

    return KeyRegistrationTransactionResponse(
      nonParticipation: null,
      selectionParticipationKey:
          const VRFKeySerializer().toJson(input.selectionPK),
      stateProofKey:
          const MerkleSignatureSerializer().toJson(input.stateProofPublicKey),
      voteFirstValid: input.voteFirst,
      voteLastValid: input.voteLast,
      voteKeyDilution: input.voteKeyDilution,
      voteParticipationKey:
          const ParticipationKeySerializer().toJson(input.votePK),
    );
  }
}
