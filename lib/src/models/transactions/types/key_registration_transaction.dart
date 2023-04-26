import 'dart:typed_data';

import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/key_registration_transaction_builder.dart';
import 'package:algorand_dart/src/models/transactions/builders/transaction_builders.dart';
import 'package:algorand_dart/src/utils/serializers/serializers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'key_registration_transaction.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
class KeyRegistrationTransaction extends RawTransaction {
  /// The root participation public key
  @JsonKey(name: 'votekey')
  @ParticipationKeySerializer()
  final ParticipationPublicKey? votePK;

  /// The VRF public key.
  @JsonKey(name: 'selkey')
  @VRFKeySerializer()
  final VRFPublicKey? selectionPK;

  /// The 64 byte state proof public key commitment.
  @JsonKey(name: 'sprfkey')
  @MerkleSignatureSerializer()
  final MerkleSignatureVerifier? stateProofPublicKey;

  /// The first round that the participation key is valid.
  /// Not to be confused with the FirstValid round of the keyreg transaction.
  @JsonKey(name: 'votefst')
  final int? voteFirst;

  /// The last round that the participation key is valid.
  /// Not to be confused with the LastValid round of the keyreg transaction.
  @JsonKey(name: 'votelst')
  final int? voteLast;

  /// This is the dilution for the 2-level participation key.
  @JsonKey(name: 'votekd')
  final int? voteKeyDilution;

  KeyRegistrationTransaction({
    this.votePK,
    this.selectionPK,
    this.stateProofPublicKey,
    this.voteFirst,
    this.voteLast,
    this.voteKeyDilution,
    BigInt? fee,
    BigInt? firstValid,
    Uint8List? genesisHash,
    BigInt? lastValid,
    Address? sender,
    String? type,
    String? genesisId,
    Uint8List? group,
    Uint8List? lease,
    Uint8List? note,
    Address? rekeyTo,
  }) : super(
          type: type,
          fee: fee,
          firstValid: firstValid,
          genesisHash: genesisHash,
          lastValid: lastValid,
          sender: sender,
          genesisId: genesisId,
          group: group,
          lease: lease,
          note: note,
          rekeyTo: rekeyTo,
        );

  KeyRegistrationTransaction.builder(KeyRegistrationTransactionBuilder builder)
      : votePK = builder.votePK,
        selectionPK = builder.selectionPK,
        stateProofPublicKey = builder.stateProofPublicKey,
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
    final stateProofBytes = stateProofPublicKey?.bytes;
    final fields = super.toMessagePack();
    fields['votekey'] = voteBytes;
    fields['selkey'] = selBytes;
    fields['sprfkey'] = stateProofBytes;
    fields['votefst'] = voteFirst;
    fields['votelst'] = voteLast;
    fields['votekd'] = voteKeyDilution;

    return fields;
  }

  factory KeyRegistrationTransaction.fromJson(Map<String, dynamic> json) =>
      _$KeyRegistrationTransactionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$KeyRegistrationTransactionToJson(this);

  @override
  List<Object?> get props => [
        ...super.props,
        votePK,
        selectionPK,
        stateProofPublicKey,
        voteFirst,
        voteLast,
        voteKeyDilution,
      ];
}
