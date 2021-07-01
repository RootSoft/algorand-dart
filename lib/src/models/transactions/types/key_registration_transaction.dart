import 'package:algorand_dart/src/models/keys/vrf_public_key.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/key_registration_transaction_builder.dart';
import 'package:algorand_dart/src/models/transactions/builders/transaction_builders.dart';

class KeyRegistrationTransaction extends RawTransaction {
  /// The root participation public key
  final ParticipationPublicKey? votePK;

  /// The VRF public key.
  final VRFPublicKey? selectionPK;

  /// The first round that the participation key is valid.
  /// Not to be confused with the FirstValid round of the keyreg transaction.
  final int? voteFirst;

  /// The last round that the participation key is valid.
  /// Not to be confused with the LastValid round of the keyreg transaction.
  final int? voteLast;

  /// This is the dilution for the 2-level participation key.
  final int? voteKeyDilution;

  KeyRegistrationTransaction.builder(KeyRegistrationTransactionBuilder builder)
      : votePK = builder.votePK,
        selectionPK = builder.selectionPK,
        voteFirst = builder.voteFirst,
        voteLast = builder.voteLast,
        voteKeyDilution = builder.voteKeyDilution,
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
    final voteBytes = votePK?.bytes;
    final selBytes = selectionPK?.bytes;
    final fields = super.toMessagePack();
    fields['votekey'] = voteBytes;
    fields['selkey'] = selBytes;
    fields['votefst'] = voteFirst;
    fields['votelst'] = voteLast;
    fields['votekd'] = voteKeyDilution;

    return fields;
  }
}
