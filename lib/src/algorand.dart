import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/api/asset/algod_asset_service.dart';
import 'package:algorand_dart/src/api/asset/assets_api.dart';
import 'package:algorand_dart/src/api/asset/indexer_asset_service.dart';
import 'package:algorand_dart/src/repositories/repositories.dart';
import 'package:algorand_dart/src/services/services.dart';
import 'package:algorand_kmd/algorand_kmd.dart';
import 'package:dio/dio.dart';

class Algorand {
  final AlgorandOptions _options;

  final NodeRepository _nodeRepository;

  final TransactionRepository _transactionRepository;

  final ApplicationRepository _applicationRepository;

  final AlgorandIndexer _indexer;

  final BlocksApi _blocksApi;

  final AssetsApi _assetsApi;

  Algorand._({
    required AlgorandOptions options,
    required NodeRepository nodeRepo,
    required TransactionRepository transactionRepo,
    required ApplicationRepository applicationRepo,
    required AlgorandIndexer indexer,
    required BlocksApi blocksApi,
    required AssetsApi assetsApi,
  })  : _options = options,
        _nodeRepository = nodeRepo,
        _transactionRepository = transactionRepo,
        _applicationRepository = applicationRepo,
        _indexer = indexer,
        _blocksApi = blocksApi,
        _assetsApi = assetsApi;

  factory Algorand({
    AlgorandOptions? options,
  }) {
    final _options = options ?? AlgorandOptions();
    final api = AlgorandApi();

    final nodeRepository = NodeRepository(
      service: NodeService(_options.algodClient.client),
    );

    final transactionRepository = TransactionRepository(
      nodeService: NodeService(_options.algodClient.client),
      transactionService: TransactionService(_options.algodClient.client),
    );

    final applicationRepository = ApplicationRepository(
      applicationService: ApplicationService(_options.algodClient.client),
    );

    final blocksApi = BlocksApi(
      BlockService(
        algod: AlgodBlockService(_options.algodClient.client),
        indexer: IndexerBlockService(_options.indexerClient.client),
      ),
    );

    final assetsApi = AssetsApi(
      api: api,
      algod: AlgodAssetService(_options.algodClient.client),
      indexer: IndexerAssetService(_options.indexerClient.client),
    );

    final indexer = AlgorandIndexer(
      indexerRepository: IndexerRepository(
        indexerService: IndexerService(_options.indexerClient.client),
        accountService: AccountService(_options.indexerClient.client),
        assetService: AssetService(_options.indexerClient.client),
        applicationService: ApplicationService(_options.indexerClient.client),
      ),
      blocksApi: blocksApi,
    );

    return Algorand._(
      options: _options,
      nodeRepo: nodeRepository,
      transactionRepo: transactionRepository,
      applicationRepo: applicationRepository,
      indexer: indexer,
      blocksApi: blocksApi,
      assetsApi: assetsApi,
    );
  }

  /// Get the key management daemon.
  DefaultApi get kmd =>
      _options.kmdClient?.api.getDefaultApi() ?? AlgorandKmd().getDefaultApi();

  /// Get the algorand indexer which lets you search the blockchain.
  AlgorandIndexer indexer() => _indexer;

  /// Set the base url of the [AlgodClient].
  void setAlgodUrl(String baseUrl) {
    _options.algodClient.client.options.baseUrl = baseUrl;
  }

  /// Set the base url of the [IndexerClient].
  void setIndexerUrl(String baseUrl) {
    _options.indexerClient.client.options.baseUrl = baseUrl;
  }

  /// Set the base url of the [IndexerClient].
  void setKmdUrl(String baseUrl) {
    _options.kmdClient?.api.dio.options.baseUrl = baseUrl;
  }

  /// Create a new, random generated account.
  Future<Account> createAccount() async {
    return Account.random();
  }

  /// Load an existing account from a private key.
  /// Private key is a hexadecimal representation of the seed.
  ///
  /// Throws [UnsupportedError] if seeds are unsupported.
  Future<Account> loadAccountFromPrivateKey(String privateKey) async {
    return Account.fromPrivateKey(privateKey);
  }

  /// Load an existing account from an rfc8037 private key.
  /// Seed is the binary representation of the seed.
  ///
  /// Throws [UnsupportedError] if seeds are unsupported.
  Future<Account> loadAccountFromSeed(List<int> seed) async {
    return Account.fromSeed(seed);
  }

  /// Load an existing account from a 25-word seed phrase.
  ///
  /// Throws [MnemonicException] if there is an invalid mnemonic/seedphrase.
  /// Throws [AlgorandException] if the account cannot be restored.
  Future<Account> restoreAccount(List<String> words) async {
    return Account.fromSeedPhrase(words);
  }

  /// Gets the genesis information.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the entire genesis file in json.
  Future<String> genesis() async {
    return _nodeRepository.genesis();
  }

  /// Checks if the node is healthy.
  ///
  /// Returns true if the node is healthy.
  Future<bool> health() async {
    return _nodeRepository.health();
  }

  /// Gets the current node status.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the current node status.
  Future<NodeStatus> status() async {
    return _nodeRepository.status();
  }

  /// Gets the node status after waiting for the given round.
  ///
  /// Waits for a block to appear after round and returns the node's
  /// status at the time.
  ///
  /// round is the round to wait until returning status
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  ///
  /// Returns the current node status.
  Future<NodeStatus> statusAfterRound(int round) async {
    return _nodeRepository.statusAfterRound(round);
  }

  /// Get the current supply reported by the ledger.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the current supply reported by the ledger.
  Future<LedgerSupply> supply() async {
    return _nodeRepository.supply();
  }

  /// Lookup a block it the given round number.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the block in the given round number.
  Future<AlgodBlock> getBlockByRound(
    int round, {
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _blocksApi.getAlgodBlockByRound(
      round,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Get the suggested parameters for constructing a new transaction.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the suggested transaction parameters.
  Future<TransactionParams> getSuggestedTransactionParams() async {
    return _transactionRepository.getSuggestedTransactionParams();
  }

  /// Broadcast a new (signed) transaction on the network.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the id of the transaction.
  Future<String> sendRawTransaction(
    Uint8List transaction, {
    bool waitForConfirmation = false,
    int? timeout,
  }) async {
    return _transactionRepository.sendRawTransaction(
      transaction,
      waitForConfirmation: waitForConfirmation,
      timeout: timeout ?? _options.timeout,
    );
  }

  /// Broadcast a list of (signed) transaction on the network.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the id of the transaction.
  Future<String> sendRawTransactions(
    List<Uint8List> transactions, {
    bool waitForConfirmation = false,
    int? timeout,
  }) async {
    return _transactionRepository.sendRawTransactions(
      transactions,
      waitForConfirmation: waitForConfirmation,
      timeout: timeout ?? _options.timeout,
    );
  }

  /// Broadcast a new (signed) transaction on the network.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the id of the transaction.
  Future<String> sendTransaction(
    SignedTransaction transaction, {
    bool waitForConfirmation = false,
    int? timeout,
  }) async {
    return _transactionRepository.sendTransaction(
      transaction,
      waitForConfirmation: waitForConfirmation,
      timeout: timeout ?? _options.timeout,
    );
  }

  /// Group a list of (signed) transactions and broadcast it on the network.
  /// This is mostly used for atomic transfers.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the id of the transaction.
  Future<String> sendTransactions(
    List<SignedTransaction> transactions, {
    bool waitForConfirmation = false,
    int? timeout,
  }) async {
    return _transactionRepository.sendTransactions(
      transactions,
      waitForConfirmation: waitForConfirmation,
      timeout: timeout ?? _options.timeout,
    );
  }

  /// Send a payment to the given recipient with the recommended transaction
  /// parameters.
  ///
  /// Account is the account used as the sender and signer of the transaction.
  /// Recipient is the address of the recipient
  /// Amount is the number of Algos to send (in microAlgos)
  /// You can pass an optional note.
  /// You can use the waitForConfirmation parameter to asynchronously wait on
  /// the transaction to be commited on the blockchain.
  ///
  /// The timeout parameter indicates how many rounds do you wish to check
  /// pending transactions for.
  ///
  /// Throws an [AlgorandException] if unable to send the payment.
  Future<String> sendPayment({
    required Account account,
    required Address recipient,
    required int amount,
    String? note,
    bool waitForConfirmation = false,
    int? timeout,
  }) async {
    // Fetch the suggested transaction params
    final params = await getSuggestedTransactionParams();

    // Build the transaction
    final transaction = await (PaymentTransactionBuilder()
          ..sender = account.address
          ..noteText = note
          ..amount = amount
          ..receiver = recipient
          ..suggestedParams = params)
        .build();

    // Sign the transaction
    final signedTx = await transaction.sign(account);

    // Send the transaction
    return sendTransaction(
      signedTx,
      waitForConfirmation: waitForConfirmation,
      timeout: timeout ?? _options.timeout,
    );
  }

  /// Get the account information of the given address.
  /// Given a specific account public key, this call returns the accounts
  /// status, balance and spendable amounts
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the account information.
  Future<AccountInformation> getAccountByAddress(String address) async {
    final response = await _indexer.getAccountById(address);

    return response.account;
  }

  /// Get the assets owned of the given address.
  /// Given a specific account public key, this call returns the assets
  /// owned by the address.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the assets.
  Future<List<AssetHolding>> getAssetsByAddress(
    String address, {
    int? assetId,
    bool? includeAll,
    int? perPage,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _assetsApi.getAssetsByAddress(
      address,
      assetId: assetId,
      includeAll: includeAll,
      perPage: perPage,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Get the assets created by the given account.
  /// Given a specific account public key, this call returns the assets
  /// created by the address.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the assets.
  Future<List<Asset>> getCreatedAssetsByAddress(
    String address, {
    int? assetId,
    bool? includeAll,
    int? perPage,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _assetsApi.getCreatedAssetsByAddress(
      address,
      assetId: assetId,
      includeAll: includeAll,
      perPage: perPage,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Get the assets created by the given account.
  /// Given a specific account public key, this call returns the assets
  /// created by the address.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the assets.
  Future<List<Application>> getCreatedApplicationsByAddress(
    String address,
  ) async {
    return _indexer.getCreatedApplicationsByAddress(address);
  }

  /// Get the balance (in microAlgos) of the given address.
  /// Given a specific account public key, this call returns the current
  /// balance.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the account's balance in microAlgos.
  Future<int> getBalance(String address) async {
    final response = await _indexer.getAccountById(address);

    return response.account.amountWithoutPendingRewards;
  }

  /// Get the list of pending transactions by address, sorted by priority,
  /// in decreasing order, truncated at the end at MAX.
  ///
  /// If MAX = 0, returns all pending transactions.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the pending transactions for the address.
  Future<PendingTransactionsResponse> getPendingTransactionsByAddress(
    String address, {
    int max = 0,
  }) async {
    return _transactionRepository.getPendingTransactionsByAddress(address,
        max: max);
  }

  /// Get the list of unconfirmed pending transactions currently in the
  /// transaction pool
  /// sorted by priority, in decreasing order, truncated at the end at MAX.
  ///
  /// If MAX = 0, returns all pending transactions.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the pending transactions.
  Future<PendingTransactionsResponse> getPendingTransactions({
    int max = 0,
  }) async {
    return _transactionRepository.getPendingTransactions(max: max);
  }

  /// Get a specific pending transaction.
  ///
  /// Given a transaction id of a recently submitted transaction, it returns
  /// information about it.
  /// There are several cases when this might succeed:
  /// - transaction committed (committed round > 0)
  /// - transaction still in the pool (committed round = 0, pool error = "")
  /// - transaction removed from pool due to error
  /// (committed round = 0, pool error != "")
  ///
  /// Or the transaction may have happened sufficiently long ago that the node
  /// no longer remembers it, and this will return an error.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the pending transaction.
  Future<PendingTransaction> getPendingTransactionById(
    String transactionId,
  ) async {
    return _transactionRepository.getPendingTransactionById(
      transactionId,
    );
  }

  /// Utility function to wait on a transaction to be confirmed.
  /// The timeout parameter indicates how many rounds do you wish to check
  /// pending transactions for.
  ///
  /// On Algorand, transactions are final as soon as they are incorporated into
  /// a block and blocks are produced, on average, every 5 seconds.
  ///
  /// This means that transactions are confirmed, on average, in 5 seconds
  Future<PendingTransaction> waitForConfirmation(
    String transactionId, {
    int? timeout,
  }) async {
    return _transactionRepository.waitForConfirmation(
      transactionId,
      timeout: timeout ?? _options.timeout,
    );
  }

  /// Compile TEAL source code to binary, produce its hash
  ///
  /// Given TEAL source code in plain text, return base64 encoded program bytes
  /// and base32 SHA512_256 hash of program bytes (Address style).
  ///
  /// This endpoint is only enabled when a node's configuration file sets
  /// EnableDeveloperAPI to true.
  Future<TealCompilation> compileTEAL(String sourceCode) async {
    return _applicationRepository.compileTEAL(sourceCode);
  }

  /// Executes TEAL program(s) in context and returns debugging information
  /// about the execution.
  /// This endpoint is only enabled when a node's configuration file sets
  /// EnableDeveloperAPI to true.
  /// /v2/teal/dryrun
  Future<DryRunResponse> dryrun(DryRunRequest request) async {
    return _applicationRepository.dryrun(request);
  }

  /// Create a new [PaymentTransaction].
  ///
  /// @param sender The sender of the payment
  /// @param receiver The receiver of the payment.
  /// @param amount The amount to sent.
  /// @param note An optional note.
  /// @param suggestedParams Optional parameters to set.
  ///
  /// @returns The constructed payment transaction.
  Future<PaymentTransaction> createPaymentTransaction({
    required Address sender,
    required Address receiver,
    required int amount,
    String? note,
    TransactionParams? suggestedParams,
  }) async {
    // Fetch the suggested transaction params
    final params = suggestedParams ?? (await getSuggestedTransactionParams());

    // Create the transaction
    final tx = await (PaymentTransactionBuilder()
          ..sender = sender
          ..receiver = receiver
          ..amount = amount
          ..noteText = note
          ..suggestedParams = params)
        .build();

    return tx;
  }

  /// Create a new [AssetConfigTransaction].
  ///
  /// @param sender The sender of the transaction.
  /// @param assetName The name of the asset
  /// @param unitName The unit name of the asset
  /// @param totalAssetsToCreate The number of total assets to create.
  /// @param decimals The number of decimals.
  ///
  /// @returns The constructed application config transaction.
  Future<AssetConfigTransaction> createAssetCreationTransaction({
    required Address sender,
    required String assetName,
    required String unitName,
    required int totalAssetsToCreate,
    required int decimals,
    bool defaultFrozen = false,
    Address? managerAddress,
    Address? reserveAddress,
    Address? freezeAddress,
    Address? clawbackAddress,
    String? url,
    String? note,
    Uint8List? metadataHash,
    TransactionParams? suggestedParams,
  }) async {
    // Fetch the suggested transaction params
    final params = suggestedParams ?? (await getSuggestedTransactionParams());

    // Create the transaction
    final transaction = await (AssetConfigTransactionBuilder()
          ..sender = sender
          ..assetName = assetName
          ..unitName = unitName
          ..totalAssetsToCreate = totalAssetsToCreate
          ..decimals = decimals
          ..defaultFrozen = defaultFrozen
          ..managerAddress = managerAddress
          ..reserveAddress = reserveAddress
          ..freezeAddress = freezeAddress
          ..clawbackAddress = clawbackAddress
          ..url = url
          ..noteText = note
          ..metaData = metadataHash
          ..suggestedParams = params)
        .build();

    return transaction;
  }

  /// Create a new [AssetTransferTransaction].
  ///
  /// @param sender The sender of the transaction.
  /// @param assetId The id of the asset to opt in.
  ///
  /// @returns The constructed application transfer transaction.
  Future<AssetTransferTransaction> createAssetOptInTransaction({
    required Address sender,
    required int assetId,
    String? note,
    TransactionParams? suggestedParams,
  }) async {
    // Fetch the suggested transaction params
    final params = suggestedParams ?? (await getSuggestedTransactionParams());

    // Create the transaction
    final tx = await (AssetTransferTransactionBuilder()
          ..assetId = assetId
          ..sender = sender
          ..receiver = sender
          ..noteText = note
          ..suggestedParams = params)
        .build();

    return tx;
  }

  /// Create a new [AssetTransferTransaction].
  ///
  /// @param sender The sender of the transaction.
  ///
  /// @returns The constructed application transfer transaction.
  Future<AssetTransferTransaction> createAssetTransferTransaction({
    required Address sender,
    int? assetId,
    int? amount,
    Address? assetSender,
    Address? receiver,
    Address? closeTo,
    TransactionParams? suggestedParams,
  }) async {
    // Fetch the suggested transaction params
    final params = suggestedParams ?? (await getSuggestedTransactionParams());

    // Create the transaction
    final tx = await (AssetTransferTransactionBuilder()
          ..sender = sender
          ..assetId = assetId
          ..amount = amount
          ..assetSender = assetSender
          ..receiver = receiver
          ..closeTo = closeTo
          ..suggestedParams = params)
        .build();

    return tx;
  }

  /// Create a new [ApplicationCreateTransaction].
  ///
  /// @param sender The sender of the transaction.
  /// @param approvalProgram The compiled approval teal program.
  /// @param clearStateProgram The compiled clear state teal program
  /// @param globalStateSchema The global state schema.
  /// @param localStateSchema The local state schema.
  ///
  /// @returns The constructed application creation transaction.
  Future<ApplicationCreateTransaction> createApplicationCreateTransaction({
    required Address sender,
    required TEALProgram approvalProgram,
    required TEALProgram clearStateProgram,
    required StateSchema globalStateSchema,
    required StateSchema localStateSchema,
    bool optIn = false,
    List<Uint8List>? arguments,
    List<Address>? accounts,
    String? note,
    TransactionParams? suggestedParams,
  }) async {
    // Fetch the suggested transaction params
    final params = suggestedParams ?? (await getSuggestedTransactionParams());

    // Create the transaction
    final tx = await (ApplicationCreateTransactionBuilder()
          ..sender = sender
          ..optIn = optIn
          ..approvalProgram = approvalProgram
          ..clearStateProgram = clearStateProgram
          ..globalStateSchema = globalStateSchema
          ..localStateSchema = localStateSchema
          ..noteText = note
          ..arguments = arguments
          ..suggestedParams = params)
        .build();

    return tx;
  }

  /// Create a new [ApplicationBaseTransaction].
  ///
  /// @param sender The sender of the transaction.
  /// @param applicationId The id of the application to call.
  ///
  /// @returns The constructed application call transaction.
  Future<ApplicationBaseTransaction> createApplicationCallTransaction({
    required Address sender,
    required int applicationId,
    List<Uint8List>? arguments,
    List<Address>? accounts,
    List<int>? foreignApps,
    List<int>? foreignAssets,
    String? note,
    OnCompletion onCompletion = OnCompletion.NO_OP_OC,
    TransactionParams? suggestedParams,
  }) async {
    // Fetch the suggested transaction params
    final params = suggestedParams ?? (await getSuggestedTransactionParams());

    // Create the transaction
    final tx = await (ApplicationCallTransactionBuilder(onCompletion)
          ..sender = sender
          ..applicationId = applicationId
          ..arguments = arguments
          ..accounts = accounts
          ..foreignApps = foreignApps
          ..foreignAssets = foreignAssets
          ..noteText = note
          ..suggestedParams = params)
        .build();

    return tx;
  }

  /// Create a new [ApplicationBaseTransaction].
  ///
  /// @param sender The sender of the transaction.
  /// @param applicationId The id of the application to delete.
  ///
  /// @returns The constructed application delete transaction.
  Future<ApplicationBaseTransaction> createApplicationDeleteTransaction({
    required Address sender,
    required int applicationId,
    List<Uint8List>? arguments,
    List<Address>? accounts,
    List<int>? foreignApps,
    List<int>? foreignAssets,
    String? note,
    TransactionParams? suggestedParams,
  }) async {
    // Fetch the suggested transaction params
    final params = suggestedParams ?? (await getSuggestedTransactionParams());

    // Create the transaction
    final tx = await (ApplicationDeleteTransactionBuilder()
          ..sender = sender
          ..applicationId = applicationId
          ..arguments = arguments
          ..accounts = accounts
          ..foreignApps = foreignApps
          ..foreignAssets = foreignAssets
          ..noteText = note
          ..suggestedParams = params)
        .build();

    return tx;
  }

  /// Create a new application opt in transaction.
  /// A helper method to easily create a new [ApplicationOptInTransaction].
  ///
  /// @param sender The sender of the transaction.
  /// @param applicationId The id of the application to opt in.
  ///
  /// @returns The constructed application delete transaction.
  Future<ApplicationBaseTransaction> createApplicationOptInTransaction({
    required Address sender,
    required int applicationId,
    List<Uint8List>? arguments,
    List<Address>? accounts,
    List<int>? foreignApps,
    List<int>? foreignAssets,
    String? note,
    TransactionParams? suggestedParams,
  }) async {
    // Fetch the suggested transaction params
    final params = suggestedParams ?? (await getSuggestedTransactionParams());

    // Create the transaction
    final tx = await (ApplicationOptInTransactionBuilder()
          ..sender = sender
          ..applicationId = applicationId
          ..arguments = arguments
          ..accounts = accounts
          ..foreignApps = foreignApps
          ..foreignAssets = foreignAssets
          ..noteText = note
          ..suggestedParams = params)
        .build();

    return tx;
  }
}
