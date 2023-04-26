import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/raw_transaction_builder.dart';
import 'package:algorand_dart/src/utils/fee_calculator.dart';

class KeyRegistrationTransactionBuilder
    extends RawTransactionBuilder<KeyRegistrationTransaction> {
  /// The root participation public key
  ParticipationPublicKey? votePK;

  /// The VRF public key.
  VRFPublicKey? selectionPK;

  /// The 64 byte state proof public key commitment.
  MerkleSignatureVerifier? stateProofPublicKey;

  /// The first round that the participation key is valid.
  /// Not to be confused with the FirstValid round of the keyreg transaction.
  int? voteFirst;

  /// The last round that the participation key is valid.
  /// Not to be confused with the LastValid round of the keyreg transaction.
  int? voteLast;

  /// This is the dilution for the 2-level participation key.
  int? voteKeyDilution;

  KeyRegistrationTransactionBuilder() : super(TransactionType.KEY_REGISTRATION);

  @override
  Future<int> estimatedTransactionSize() async {
    return await FeeCalculator.estimateTransactionSize(
      KeyRegistrationTransaction.builder(this),
    );
  }

  @override
  Future<KeyRegistrationTransaction> build() async {
    await super.build();

    return KeyRegistrationTransaction.builder(this);
  }
}
