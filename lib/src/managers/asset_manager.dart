import 'package:algorand_dart/src/exceptions/exceptions.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/transaction_builders.dart';
import 'package:algorand_dart/src/repositories/repositories.dart';

class AssetManager {
  /// Repository used to perform transaction related tasks.
  final TransactionRepository transactionRepository;

  AssetManager({required this.transactionRepository});

  /// Create a new asset (Algorand Standard Asset).
  /// This is a helper function to create a new asset.
  ///
  /// With Algorand Standard Assets you can represent stablecoins,
  /// loyalty points, system credits, and in-game points, ...
  ///
  /// Fungible asset: Assets that represent many of the same type (stablecoins)
  /// Non-fungible asset: Single, unique assets.
  ///
  /// Account is the account used to create and sign the asset.
  /// Asset name is the name of the asset (Algorand)
  /// Unit name is the unit name of the asset (e.g ALGO)
  /// Total assets is the number of total assets.
  /// Decimals is the number of decimals
  ///
  /// Throws [AlgorandException] if unable to create the asset or send the
  /// transaction.
  /// Returns the transaction id.
  Future<String> createAsset({
    required Account account,
    required String assetName,
    required String unitName,
    required BigInt totalAssets,
    required int decimals,
    bool defaultFrozen = false,
    Address? managerAddress,
    Address? reserveAddress,
    Address? freezeAddress,
    Address? clawbackAddress,
  }) async {
    // Fetch the suggested transaction params
    final params = await transactionRepository.getSuggestedTransactionParams();

    final transaction = await (AssetConfigTransactionBuilder()
          ..assetName = assetName
          ..unitName = unitName
          ..totalAssetsToCreate = totalAssets
          ..decimals = decimals
          ..defaultFrozen = defaultFrozen
          ..managerAddress = managerAddress
          ..reserveAddress = reserveAddress
          ..freezeAddress = freezeAddress
          ..clawbackAddress = clawbackAddress
          ..sender = account.address
          ..suggestedParams = params)
        .build();

    // Sign the transactions
    final signedTransaction = await transaction.sign(account);

    // Send the transaction
    return await transactionRepository.sendTransaction(signedTransaction);
  }

  /// Edit an existing asset.
  ///
  /// After an asset has been created only the manager, reserve, freeze and
  /// clawback accounts can be changed.
  /// All other parameters are locked for the life of the asset.
  ///
  /// If any of these addresses are set to "" that address will be cleared and
  /// can never be reset for the life of the asset.
  /// Only the manager account can make configuration changes and must authorize
  /// the transaction.
  ///
  /// Throws [AlgorandException] if unable to edit the asset or send the
  /// transaction.
  ///
  /// Returns the transaction id.
  Future<String> editAsset({
    required int assetId,
    required Account account,
    Address? managerAddress,
    Address? reserveAddress,
    Address? freezeAddress,
    Address? clawbackAddress,
  }) async {
    // Fetch the suggested transaction params
    final params = await transactionRepository.getSuggestedTransactionParams();

    final transaction = await (AssetConfigTransactionBuilder()
          ..assetId = assetId
          ..managerAddress = managerAddress
          ..reserveAddress = reserveAddress
          ..freezeAddress = freezeAddress
          ..clawbackAddress = clawbackAddress
          ..sender = account.address
          ..suggestedParams = params)
        .build();

    // Sign the transactions
    final signedTransaction = await transaction.sign(account);

    // Send the transaction
    return await transactionRepository.sendTransaction(signedTransaction);
  }

  /// Destroy (remove) an existing asset from the Algorand ledger.
  ///
  /// A Destroy Transaction is issued to remove an asset from the Algorand
  /// ledger.
  ///
  /// To destroy an existing asset on Algorand, the original creator must be
  /// in possession of all units of the asset
  /// and the manager must send and therefore authorize the transaction.
  ///
  /// Throws [AlgorandException] if unable to destroy the asset or send the
  /// transaction.
  ///
  /// Returns the transaction id.
  Future<String> destroyAsset({
    required int assetId,
    required Account account,
  }) async {
    // Fetch the suggested transaction params
    final params = await transactionRepository.getSuggestedTransactionParams();

    final transaction = await (AssetConfigTransactionBuilder()
          ..assetId = assetId
          ..destroy = true
          ..sender = account.address
          ..suggestedParams = params)
        .build();

    // Sign the transactions
    final signedTransaction = await transaction.sign(account);

    // Send the transaction
    return await transactionRepository.sendTransaction(signedTransaction);
  }

  /// Opt-in to receive an asset
  /// An opt-in transaction is simply an asset transfer with an amount of 0,
  /// both to and from the account opting in.
  ///
  /// Assets can be transferred between accounts that have opted-in to receiving
  /// the asset.
  ///
  /// These are analogous to standard payment transactions but for
  /// Algorand Standard Assets.
  ///
  /// Throws [AlgorandException] if unable to opt in to the the asset or send
  /// the transaction.
  ///
  /// Returns the transaction id.
  Future<String> optIn({
    required int assetId,
    required Account account,
  }) async {
    // Fetch the suggested transaction params
    final params = await transactionRepository.getSuggestedTransactionParams();

    // Opt-in to the asset
    final transaction = await (AssetTransferTransactionBuilder()
          ..assetId = assetId
          ..receiver = account.address
          ..sender = account.address
          ..suggestedParams = params)
        .build();

    // Sign the transactions
    final signedTransaction = await transaction.sign(account);

    // Send the transaction
    return await transactionRepository.sendTransaction(signedTransaction);
  }

  /// Transfer an asset from the account to the receiver.
  /// Assets can be transferred between accounts that have opted-in to
  /// receiving the asset.
  ///
  /// These are analogous to standard payment transactions but for
  /// Algorand Standard Assets.
  ///
  /// Throws [AlgorandException] if unable to transfer the asset or send the
  /// transaction.
  ///
  /// Returns the transaction id.
  Future<String> transfer({
    required int assetId,
    required Account account,
    required Address receiver,
    required BigInt amount,
  }) async {
    // Fetch the suggested transaction params
    final params = await transactionRepository.getSuggestedTransactionParams();

    // Transfer the asset
    final transaction = await (AssetTransferTransactionBuilder()
          ..assetId = assetId
          ..amount = amount
          ..sender = account.address
          ..receiver = receiver
          ..suggestedParams = params)
        .build();

    // Sign the transactions
    final signedTransaction = await transaction.sign(account);

    // Send the transaction
    return await transactionRepository.sendTransaction(signedTransaction);
  }

  /// Freeze or unfreeze an asset for an account.
  /// Freezing or unfreezing an asset requires a transaction that is signed by
  /// the freeze account.
  ///
  /// Upon creation of an asset, you can specify a freeze address and a
  /// defaultfrozen state.
  ///
  /// If the defaultfrozen state is set to true the corresponding freeze address
  /// must issue unfreeze transactions, to allow trading of the asset to and
  /// from that account.
  ///
  /// This may be useful in situations that require holders of the asset to pass
  /// certain checks prior to ownership.
  ///
  /// If the defaultfrozen state is set to false anyone would be allowed to
  /// trade the asset and the freeze address could issue freeze transactions to
  /// specific accounts to disallow trading of that asset.
  ///
  /// If you want to ensure to asset holders that the asset will never be
  /// frozen,  set the defaultfrozen state to false and set the freeze address
  /// to null or an empty string in goal and the SDKs.
  ///
  /// Throws [AlgorandException] if unable to freeze the asset or send the
  /// transaction.
  ///
  /// Returns the transaction id.
  Future<String> freeze({
    required int assetId,
    required Account account,
    required Address freezeTarget,
    required bool freeze,
  }) async {
    // Fetch the suggested transaction params
    final params = await transactionRepository.getSuggestedTransactionParams();

    // Transfer the asset
    final transaction = await (AssetFreezeTransactionBuilder()
          ..assetId = assetId
          ..freezeTarget = freezeTarget
          ..freeze = freeze
          ..sender = account.address
          ..suggestedParams = params)
        .build();

    // Sign the transactions
    final signedTransaction = await transaction.sign(account);

    // Send the transaction
    return await transactionRepository.sendTransaction(signedTransaction);
  }

  /// Revokes an asset for a given account.
  ///
  /// Revoking an asset for an account removes a specific number of the asset
  /// from the revoke target account.
  ///
  /// Revoking an asset from an account requires specifying an asset sender
  /// (the revoke target account) and an asset receiver (the account to
  /// transfer the funds back to).
  ///
  /// The clawback address, if specified, is able to revoke the asset from any
  /// account and place them in any other account that has previously opted-in.
  ///
  /// This may be useful in situations where a holder of the asset breaches
  /// some set of terms that you established for that asset.
  /// You could issue a freeze transaction to investigate, and if you determine
  /// that they can no longer own the asset, you could revoke the assets.
  ///
  /// Similar to freezing, if you would rather ensure to asset holders that you
  /// will never have the ability to revoke assets, set the clawback address
  /// to null.
  ///
  /// Throws [AlgorandException] if unable to revoke the asset or send the
  /// transaction.
  ///
  /// Returns the transaction id.
  Future<String> revoke({
    required int assetId,
    required Account account,
    required BigInt amount,
    required Address revokeAddress,
    Address? clawbackAddress,
  }) async {
    // Fetch the suggested transaction params
    final params = await transactionRepository.getSuggestedTransactionParams();

    // Transfer the asset
    final transaction = await (AssetTransferTransactionBuilder()
          ..assetId = assetId
          ..amount = amount
          ..assetSender = revokeAddress
          ..receiver = clawbackAddress ?? account.address
          ..sender = account.address
          ..suggestedParams = params)
        .build();

    // Sign the transactions
    final signedTransaction = await transaction.sign(account);

    // Send the transaction
    return await transactionRepository.sendTransaction(signedTransaction);
  }
}
