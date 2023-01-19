import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/src/abi/transaction_signer.dart';
import 'package:algorand_dart/src/api/account/account.dart';
import 'package:algorand_dart/src/crypto/crypto.dart' as crypto;
import 'package:algorand_dart/src/exceptions/exceptions.dart';
import 'package:algorand_dart/src/mnemonic/mnemonic.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

class Account implements TxnSigner {
  /// Prefix for signing bytes
  static const BYTES_SIGN_PREFIX = 'MX';

  final SimplePublicKey publicKey;

  final SimpleKeyPair keyPair;

  final Address address;

  final String? name;

  final AccountType accountType;

  Account._create({
    required this.publicKey,
    required this.keyPair,
    this.name,
    this.accountType = AccountType.single,
  }) : address = Address(publicKey: Uint8List.fromList(publicKey.bytes));

  /// Create a new, random generated account.
  static Future<Account> random({
    String? name,
    AccountType accountType = AccountType.single,
  }) async {
    final keyPair = await Ed25519().newKeyPair();
    final publicKey = await keyPair.extractPublicKey();
    final account = Account._create(
      publicKey: publicKey,
      keyPair: keyPair,
      name: name,
      accountType: accountType,
    );

    return account;
  }

  /// Load an existing account from a private key.
  /// Private key is a hexadecimal representation of the seed.
  ///
  /// Throws [UnsupportedError] if seeds are unsupported.
  static Future<Account> fromPrivateKey(
    String privateKey, {
    String? name,
    AccountType accountType = AccountType.single,
  }) async {
    // TODO Derive the seed from the private key
    final keyPair = await Ed25519().newKeyPairFromSeed(hex.decode(privateKey));
    final publicKey = await keyPair.extractPublicKey();
    final account = Account._create(
      publicKey: publicKey,
      keyPair: keyPair,
      name: name,
      accountType: accountType,
    );

    return account;
  }

  /// Load an existing account from an rfc8037 private key.
  /// Seed is the binary representation of the seed.
  ///
  /// Throws [UnsupportedError] if seeds are unsupported.
  static Future<Account> fromSeed(
    List<int> seed, {
    String? name,
    AccountType accountType = AccountType.single,
  }) async {
    final keyPair = await Ed25519().newKeyPairFromSeed(seed);
    final publicKey = await keyPair.extractPublicKey();
    final account = Account._create(
      publicKey: publicKey,
      keyPair: keyPair,
      name: name,
      accountType: accountType,
    );

    return account;
  }

  /// Load an existing account from a 25-word seed phrase.
  ///
  /// Throws [MnemonicException] if there is an invalid mnemonic/seedphrase.
  /// Throws [AlgorandException] if the account cannot be restored.
  /// Throws [UnsupportedError] if seeds are unsupported.
  static Future<Account> fromSeedPhrase(
    List<String> words, {
    String? name,
    AccountType accountType = AccountType.single,
  }) async {
    // Get the seed from the mnemonic.
    final seed = await Mnemonic.seed(words);
    return fromSeed(
      seed,
      name: name,
      accountType: accountType,
    );
  }

  /// Get the public, human readable address of the account,
  /// also known as the Algorand address.
  String get publicAddress => address.encodedAddress;

  /// Get the 25-word seed phrase/mnemonic.
  ///
  /// This converts the private 32-byte key into a 25 word mnemonic.
  /// The generated mnemonic includes a checksum.
  /// Each word in the mnemonic represents 11 bits of data, and the last 11 bits
  /// are reserved for the checksum.
  ///
  /// https://developer.algorand.org/docs/features/accounts/#transformation-private-key-to-25-word-mnemonic
  ///
  /// Throws [MnemonicException] when unable to create the seed phrase.
  /// Returns the seed phrase which is a list containing 25 words.
  Future<List<String>> get seedPhrase async {
    // Get seed from private key
    final privateKeyBytes = await keyPair.extractPrivateKeyBytes();

    // Generate mnemonic from seed
    return await Mnemonic.generate(privateKeyBytes);
  }

  /// Sign the given bytes with the secret key.
  Future<crypto.Signature> sign(Uint8List bytes) async {
    // Sign the transaction with secret key
    final signature = await Ed25519().sign(
      bytes,
      keyPair: keyPair,
    );

    return crypto.Signature(bytes: Uint8List.fromList(signature.bytes));
  }

  /// Sign the given bytes, and wrap in signature.
  /// The message is prepended with "MX" for domain separation.
  Future<crypto.Signature> signBytes(Uint8List bytes) async {
    // Prepend the bytes
    final signPrefix = utf8.encode(BYTES_SIGN_PREFIX);

    // Merge the byte arrays
    final buffer = Uint8List.fromList([
      ...signPrefix,
      ...bytes,
    ]);

    // Sign the transaction with secret key
    final signature = await Ed25519().sign(
      buffer,
      keyPair: keyPair,
    );

    return crypto.Signature(bytes: Uint8List.fromList(signature.bytes));
  }

  @override
  Future<List<SignedTransaction>> signTransactions(
    List<RawTransaction> transactions,
    List<int> indicesToSign,
  ) async {
    final signedTxns = <SignedTransaction>[];
    for (var i = 0; i < indicesToSign.length; i++) {
      final txn = transactions[indicesToSign[i]];
      final signedTxn = await txn.sign(this);
      signedTxns.add(signedTxn);
    }

    return signedTxns;
  }
}
