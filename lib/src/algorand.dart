import 'dart:typed_data';

import 'package:algorand_dart/src/api/responses.dart';
import 'package:algorand_dart/src/clients/clients.dart';
import 'package:algorand_dart/src/exceptions/exceptions.dart';
import 'package:algorand_dart/src/indexer/algorand_indexer.dart';
import 'package:algorand_dart/src/managers/managers.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/transaction_builders.dart';
import 'package:algorand_dart/src/repositories/repositories.dart';
import 'package:algorand_dart/src/services/services.dart';
import 'package:algorand_kmd/algorand_kmd.dart';

class Algorand {
  /// The HTTP Client instance to interact with algod.
  final AlgodClient _algodClient;

  /// The HTTP Client instance to interact with the indexer.
  final IndexerClient _indexerClient;

  /// The HTTP Client instance to interact with kmd.
  final KmdClient? _kmdClient;

  late final NodeRepository _nodeRepository;

  late final TransactionRepository _transactionRepository;

  late final AccountRepository _accountRepository;

  late final ApplicationRepository _applicationRepository;

  /// Manages everything related to assets.
  late final AssetManager _assetManager;

  /// Manages everything related to applications & TEAL.
  late final ApplicationManager _applicationManager;

  late final AlgorandIndexer _indexer;

  Algorand({
    AlgodClient? algodClient,
    IndexerClient? indexerClient,
    KmdClient? kmdClient,
  })  : _algodClient = algodClient ?? AlgodClient(apiUrl: ''),
        _indexerClient = indexerClient ?? IndexerClient(apiUrl: ''),
        _kmdClient = kmdClient {
    // TODO Provide services
    final transactionService = TransactionService(_algodClient.client);
    final nodeService = NodeService(_algodClient.client);

    // TODO Inject Repositories
    _nodeRepository = NodeRepository(service: nodeService);
    _transactionRepository = TransactionRepository(
      nodeService: nodeService,
      transactionService: transactionService,
    );

    _accountRepository = AccountRepository(
      accountService: AccountService(_algodClient.client),
    );

    _applicationRepository = ApplicationRepository(
      applicationService: ApplicationService(_algodClient.client),
    );

    // TODO Inject Managers
    _assetManager = AssetManager(transactionRepository: _transactionRepository);
    _applicationManager = ApplicationManager(
      applicationRepository: _applicationRepository,
      transactionRepository: _transactionRepository,
    );

    // TODO Inject and provide the Algorand Indexer
    _indexer = AlgorandIndexer(
      indexerRepository: IndexerRepository(
        indexerService: IndexerService(_indexerClient.client),
        accountService: AccountService(_indexerClient.client),
        assetService: AssetService(_indexerClient.client),
        applicationService: ApplicationService(_indexerClient.client),
      ),
    );
  }

  /// Get the asset manager, used to perform asset related tasks.
  AssetManager get assetManager => _assetManager;

  /// Get the application manager, used to perform application related tasks.
  ApplicationManager get applicationManager => _applicationManager;

  /// Get the key management daemon.
  DefaultApi get kmd =>
      _kmdClient?.api.getDefaultApi() ?? AlgorandKmd().getDefaultApi();

  /// Get the algorand indexer which lets you search the blockchain.
  AlgorandIndexer indexer() => _indexer;

  /// Create a new, random generated account.
  Future<Account> createAccount() async {
    return await Account.random();
  }

  /// Load an existing account from a private key.
  /// Private key is a hexadecimal representation of the seed.
  ///
  /// Throws [UnsupportedError] if seeds are unsupported.
  Future<Account> loadAccountFromPrivateKey(String privateKey) async {
    return await Account.fromPrivateKey(privateKey);
  }

  /// Load an existing account from an rfc8037 private key.
  /// Seed is the binary representation of the seed.
  ///
  /// Throws [UnsupportedError] if seeds are unsupported.
  Future<Account> loadAccountFromSeed(List<int> seed) async {
    return await Account.fromSeed(seed);
  }

  /// Load an existing account from a 25-word seed phrase.
  ///
  /// Throws [MnemonicException] if there is an invalid mnemonic/seedphrase.
  /// Throws [AlgorandException] if the account cannot be restored.
  Future<Account> restoreAccount(List<String> words) async {
    return await Account.fromSeedPhrase(words);
  }

  /// Gets the genesis information.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the entire genesis file in json.
  Future<String> genesis() async {
    return await _nodeRepository.genesis();
  }

  /// Checks if the node is healthy.
  ///
  /// Returns true if the node is healthy.
  Future<bool> health() async {
    return await _nodeRepository.health();
  }

  /// Gets the current node status.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the current node status.
  Future<NodeStatus> status() async {
    return await _nodeRepository.status();
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
    return await _nodeRepository.statusAfterRound(round);
  }

  /// Get the current supply reported by the ledger.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the current supply reported by the ledger.
  Future<LedgerSupply> supply() async {
    return await _nodeRepository.supply();
  }

  /// Get the suggested parameters for constructing a new transaction.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the suggested transaction parameters.
  Future<TransactionParams> getSuggestedTransactionParams() async {
    return await _transactionRepository.getSuggestedTransactionParams();
  }

  /// Broadcast a new (signed) transaction on the network.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the id of the transaction.
  Future<String> sendRawTransaction(
    Uint8List transaction, {
    bool waitForConfirmation = false,
    int timeout = 5,
  }) async {
    return await _transactionRepository.sendRawTransaction(
      transaction,
      waitForConfirmation: waitForConfirmation,
      timeout: timeout,
    );
  }

  /// Broadcast a list of (signed) transaction on the network.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the id of the transaction.
  Future<String> sendRawTransactions(
    List<Uint8List> transactions, {
    bool waitForConfirmation = false,
    int timeout = 5,
  }) async {
    return await _transactionRepository.sendRawTransactions(
      transactions,
      waitForConfirmation: waitForConfirmation,
      timeout: timeout,
    );
  }

  /// Broadcast a new (signed) transaction on the network.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the id of the transaction.
  Future<String> sendTransaction(
    SignedTransaction transaction, {
    bool waitForConfirmation = false,
    int timeout = 5,
  }) async {
    return await _transactionRepository.sendTransaction(
      transaction,
      waitForConfirmation: waitForConfirmation,
      timeout: timeout,
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
    int timeout = 5,
  }) async {
    return await _transactionRepository.sendTransactions(
      transactions,
      waitForConfirmation: waitForConfirmation,
      timeout: timeout,
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
    int timeout = 5,
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
    return await sendTransaction(
      signedTx,
      waitForConfirmation: waitForConfirmation,
      timeout: timeout,
    );
  }

  /// Get the account information of the given address.
  /// Given a specific account public key, this call returns the accounts
  /// status, balance and spendable amounts
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the account information.
  Future<AccountInformation> getAccountByAddress(String address) async {
    return await _accountRepository.getAccountByAddress(address);
  }

  /// Get the balance (in microAlgos) of the given address.
  /// Given a specific account public key, this call returns the current
  /// balance.
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the account's balance in microAlgos.
  Future<int> getBalance(String address) async {
    final accountInformation =
        await _accountRepository.getAccountByAddress(address);
    return accountInformation.amountWithoutPendingRewards;
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
    return await _transactionRepository.getPendingTransactionsByAddress(address,
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
    return await _transactionRepository.getPendingTransactions(max: max);
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
    return await _transactionRepository.getPendingTransactionById(
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
    int timeout = 5,
  }) async {
    return await _transactionRepository.waitForConfirmation(
      transactionId,
      timeout: timeout,
    );
  }

  /// Register an account online.
  ///
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the pending transaction.
  Future<String> registerOnline({
    required ParticipationPublicKey votePK,
    required VRFPublicKey selectionPK,
    required int voteFirst,
    required int voteLast,
    required int voteKeyDilution,
    required Account account,
  }) async {
    // Fetch the suggested transaction params
    final params = await _transactionRepository.getSuggestedTransactionParams();

    // Transfer the asset
    final transaction = await (KeyRegistrationTransactionBuilder()
          ..votePK = votePK
          ..selectionPK = selectionPK
          ..voteFirst = voteFirst
          ..voteLast = voteLast
          ..voteKeyDilution = voteKeyDilution
          ..sender = account.address
          ..suggestedParams = params)
        .build();

    // Sign the transactions
    final signedTransaction = await transaction.sign(account);

    // Send the transaction
    return await _transactionRepository.sendTransaction(signedTransaction);
  }

  /// Register an account offline.
  ///
  ///
  /// Throws an [AlgorandException] if there is an HTTP error.
  /// Returns the pending transaction.
  Future<String> registerOffline({
    required Account account,
  }) async {
    // Fetch the suggested transaction params
    final params = await _transactionRepository.getSuggestedTransactionParams();

    // Transfer the asset
    final transaction = await (KeyRegistrationTransactionBuilder()
          ..votePK = null
          ..selectionPK = null
          ..voteFirst = null
          ..voteLast = null
          ..voteKeyDilution = null
          ..sender = account.address
          ..suggestedParams = params)
        .build();

    // Sign the transactions
    final signedTransaction = await transaction.sign(account);

    // Send the transaction
    return await _transactionRepository.sendTransaction(signedTransaction);
  }
}
