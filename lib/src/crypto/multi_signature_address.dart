import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/src/crypto/crypto.dart';
import 'package:algorand_dart/src/exceptions/exceptions.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/utils/message_packable.dart';
import 'package:algorand_dart/src/utils/serializers/serializers.dart';
import 'package:buffer/buffer.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'multi_signature_address.g.dart';

/// Multisignature accounts are a logical representation of an ordered set of
/// addresses with a threshold and version.
///
/// Multisignature accounts can perform the same operations as other accounts,
/// including sending transactions and participating in consensus.
///
/// The address for a multisignature account is essentially a hash of the
/// ordered list of accounts, the threshold and version values.
/// The threshold determines how many signatures are required to process any
/// transaction from this multisignature account.
///
/// MultisigAddress is a convenience class for handling multisignature public
/// identities.

@JsonSerializable(fieldRename: FieldRename.kebab)
class MultiSigAddress extends Equatable implements MessagePackable {
  static const MULTISIG_PREFIX = 'MultisigAddr';

  @JsonKey(name: 'version', defaultValue: 1)
  final int version;

  @JsonKey(name: 'threshold', defaultValue: 2)
  final int threshold;

  @JsonKey(name: 'addrs', defaultValue: [])
  @ListAddressConverter()
  final List<Address> publicKeys;

  MultiSigAddress({
    required this.version,
    required this.threshold,
    required this.publicKeys,
  }) {
    if (version != 1) {
      throw AlgorandException(message: 'Unknown msig version');
    }
    if (threshold == 0 || publicKeys.isEmpty || threshold > publicKeys.length) {
      throw AlgorandException(message: 'Invalid threshold');
    }
  }

  /// Creates a multisig transaction from the input and the multisig account.
  Future<SignedTransaction> sign({
    required Account account,
    required RawTransaction transaction,
  }) async {
    final sender = transaction.sender;
    final address = toAddress();
    if (sender == null) {
      throw AlgorandException(message: 'Sender is not valid');
    }

    // check that account secret key is in multisig pk list

    final index = publicKeys.indexOf(account.address);
    if (index == -1) {
      throw AlgorandException(
        message: 'Multisig account does not contain this secret key',
      );
    }

    // Create the multisignature
    final signedTx = await transaction.sign(account);

    final subsigs = <MultisigSubsig>[];
    for (var i = 0; i < publicKeys.length; i++) {
      if (i == index) {
        subsigs.add(
          MultisigSubsig(
            key: account.address,
            signature: Signature(
              bytes: signedTx.signature ?? Uint8List.fromList([]),
            ),
          ),
        );
      } else {
        subsigs.add(MultisigSubsig(key: publicKeys[i]));
      }
    }

    final mSig = MultiSignature(
      version: version,
      threshold: threshold,
      subsigs: subsigs,
    );

    final msigTx = SignedTransaction(
      transaction: transaction,
      multiSignature: mSig,
      transactionId: signedTx.transactionId,
    );

    if (sender.encodedAddress != address.encodedAddress) {
      msigTx.authAddress = address;
    }

    return msigTx;
  }

  /// Appends our signature to the given multisig transaction.
  /// Transaction is the partially signed msig tx to which to append signature.
  /// Returns a merged multisig transaction.
  Future<SignedTransaction> append({
    required Account account,
    required SignedTransaction transaction,
  }) async {
    final signedTx = await sign(
      account: account,
      transaction: transaction.transaction,
    );

    return mergeMultisigTransactions([signedTx, transaction]);
  }

  /// Convert the MultiSignature Address to more easily represent as a string.
  Address toAddress() {
    final numPkBytes = Ed25519PublicKey.KEY_LEN_BYTES * publicKeys.length;
    final length = MULTISIG_PREFIX.length + 2 + numPkBytes;
    final writer = ByteDataWriter(bufferLength: length);
    writer.write(utf8.encode(MULTISIG_PREFIX));
    writer.writeUint8(version);
    writer.writeUint8(threshold);
    for (var key in publicKeys) {
      writer.write(key.publicKey);
    }

    final digest = sha512256.convert(writer.toBytes());
    return Address(publicKey: Uint8List.fromList(digest.bytes));
  }

  /// Merges the given (partially) signed multisig transactions.
  /// Transactions are the partially signed multisig transactions to merge.
  /// Underlying transactions may be mutated.
  ///
  /// Returns the merged multisig transaction
  static Future<SignedTransaction> mergeMultisigTransactions(
    List<SignedTransaction> transactions,
  ) async {
    if (transactions.length < 2) {
      throw AlgorandException(message: 'Cannot merge a single transaction');
    }

    final merged = transactions[0];
    for (var i = 0; i < transactions.length; i++) {
      final tx = transactions[i];
      final mSig = tx.multiSignature;
      if (mSig == null) {
        throw AlgorandException(message: 'No valid multisignature');
      }

      if (mSig.version != merged.multiSignature?.version ||
          mSig.threshold != merged.multiSignature?.threshold) {
        throw AlgorandException(
          message: 'transaction msig parameters do not match',
        );
      }

      for (var j = 0; j < mSig.subsigs.length; j++) {
        var myMsig = merged.multiSignature?.subsigs[j];
        var theirMsig = mSig.subsigs[j];
        if (myMsig == null) {
          throw AlgorandException(message: 'No valid subsig');
        }

        if (theirMsig.key != myMsig.key) {
          throw AlgorandException(
            message: 'transaction msig public keys do not match',
          );
        }

        if (myMsig.signature == null) {
          myMsig = myMsig.copyWith(signature: theirMsig.signature);
        } else if (myMsig.signature != theirMsig.signature &&
            theirMsig.signature != null) {
          throw AlgorandException(
            message: 'transaction msig has mismatched signatures',
          );
        }

        merged.multiSignature?.subsigs[j] = myMsig;
      }
    }

    return merged;
  }

  /// Helper method to convert list of byte[]s to list of Ed25519PublicKeys.
  static List<Ed25519PublicKey> toKeys(List<Uint8List> keys) {
    return keys.map((key) => Ed25519PublicKey(bytes: key)).toList();
  }

  factory MultiSigAddress.fromJson(Map<String, dynamic> json) =>
      _$MultiSigAddressFromJson(json);

  Map<String, dynamic> toJson() => _$MultiSigAddressToJson(this);

  @override
  Map<String, dynamic> toMessagePack() {
    return {
      'version': version,
      'threshold': threshold,
      'publicKeys': publicKeys.map((key) => key.publicKey).toList(),
    };
  }

  @override
  String toString() {
    return toAddress().encodedAddress;
  }

  @override
  List<Object?> get props => [version, threshold, ...publicKeys];
}
