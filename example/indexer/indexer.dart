import 'package:algorand_dart/algorand_dart.dart';
import 'package:dio/dio.dart';

void main() async {
  final algodClient = AlgodClient(
    apiUrl: AlgoExplorer.TESTNET_ALGOD_API_URL,
  );

  final indexerClient = IndexerClient(
    apiUrl: AlgoExplorer.TESTNET_INDEXER_API_URL,
  );

  final algorand = Algorand(
    algodClient: algodClient,
    indexerClient: indexerClient,
  );

  final words =
      // ignore: lines_longer_than_80_chars
      'chronic reason target blood lend major world lottery border top quantum turtle fiber debate impose meadow sport exclude nut window awesome want myself ability chief';
  final account = await Account.fromSeedPhrase(words.split(' '));

  // Get account information
  await getAccountInformation(algorand: algorand, account: account);

  await getAccountInfoBlock(algorand: algorand, account: account);

  // Find an asset by a given id.
  await findAssetById(algorand: algorand, account: account);

  // Searches for asset greater than currencyGreaterThan
  await findAssetMinBalances(algorand: algorand, account: account);

  // Lookup the list of accounts who hold this asset
  await findAssetBalances(algorand: algorand, account: account);

  // Lookup the list of accounts who hold this asset
  await findAssetsBalanceMinBalance(algorand: algorand, account: account);

  // Lookup block info at a given round
  await getBlockInfo(algorand: algorand, account: account);

  // Find application with a given id
  await findApplication(algorand: algorand, account: account);

  // Allow searching all applications on the blockchain.
  await searchApplications(algorand: algorand, account: account);

  // Search assets by name
  await searchAssetsByName(algorand: algorand, account: account);

  // Search asset transaction with the given role
  await searchAssetsTransactionsRole(algorand: algorand, account: account);

  // Search transactions
  await searchTransactions(algorand: algorand, account: account);

  // Search transactions prefixed with a note
  await searchTransactionsWithNote(algorand: algorand, account: account);

  // Page through transactions
  await searchTransactionsPaging(algorand: algorand, account: account);
}

Future getAccountInformation({
  required Algorand algorand,
  required Account account,
}) async {
  final information = await algorand.getAccountByAddress(account.publicAddress);
  print(information.address);
}

Future getAccountInfoBlock({
  required Algorand algorand,
  required Account account,
}) async {
  final information = await algorand.indexer().getAccountById(
        account.publicAddress,
        round: 16280357,
      );
  print(information.account.address);
}

Future findAssetById({
  required Algorand algorand,
  required Account account,
}) async {
  final response = await algorand.indexer().getAssetById(408947);
  print(response.toJson());
}

Future findAssetMinBalances({
  required Algorand algorand,
  required Account account,
}) async {
  try {
    // Might not work with AlgoExplorer API!
    final response = await algorand
        .indexer()
        .assets()
        .whereAssetId(408947)
        .whereCurrencyIsGreaterThan(3007326000)
        .search();

    print(response.toJson());
  } on AlgorandException catch (ex) {
    final error = ex.cause as DioError;
    print(error.response?.toString());
  }
}

/// Lookup the list of accounts who hold this asset.
Future findAssetBalances({
  required Algorand algorand,
  required Account account,
}) async {
  try {
    final response =
        await algorand.indexer().accounts().balances(440307).search();

    print(response.toJson());
  } on AlgorandException catch (ex) {
    final error = ex.cause as DioError;
    print(error.response?.toString());
  }
}

/// Lookup the list of accounts who hold this asset.
Future findAssetsBalanceMinBalance({
  required Algorand algorand,
  required Account account,
}) async {
  try {
    final response = await algorand
        .indexer()
        .accounts()
        .balances(440307)
        .whereCurrencyIsGreaterThan(0)
        .search();

    print(response.toJson());
  } on AlgorandException catch (ex) {
    final error = ex.cause as DioError;
    print(error.response?.toString());
  }
}

/// Lookup a block it the given round number.
Future getBlockInfo({
  required Algorand algorand,
  required Account account,
}) async {
  try {
    final response = await algorand.indexer().getBlockByRound(16280357);
    print(response.toJson());
  } on AlgorandException catch (ex) {
    final error = ex.cause as DioError;
    print(error.response?.toString());
  }
}

/// Lookup a block it the given round number.
Future findApplication({
  required Algorand algorand,
  required Account account,
}) async {
  try {
    final response = await algorand.indexer().getApplicationById(15974179);
    print(response.toJson());
  } on AlgorandException catch (ex) {
    final error = ex.cause as DioError;
    print(error.response?.toString());
  }
}

/// Allow searching all applications on the blockchain.
Future searchApplications({
  required Algorand algorand,
  required Account account,
}) async {
  try {
    final response = await algorand.indexer().applications().search(limit: 4);
    print(response.toJson());
  } on AlgorandException catch (ex) {
    final error = ex.cause as DioError;
    print(error.response?.toString());
  }
}

/// Allow searching all applications on the blockchain.
Future searchAssets({
  required Algorand algorand,
  required Account account,
}) async {
  try {
    final response = await algorand.indexer().assets().search(limit: 4);
    print(response.toJson());
  } on AlgorandException catch (ex) {
    final error = ex.cause as DioError;
    print(error.response?.toString());
  }
}

/// Allow searching all assets by name on the blockchain.
Future searchAssetsByName({
  required Algorand algorand,
  required Account account,
}) async {
  try {
    final response =
        await algorand.indexer().assets().whereAssetName('Mario').search();

    print(response.toJson());
  } on AlgorandException catch (ex) {
    final error = ex.cause as DioError;
    print(error.response?.toString());
  }
}

Future searchAssetsTransactionsRole({
  required Algorand algorand,
  required Account account,
}) async {
  try {
    final address = Address.fromAlgorandAddress(
      address: 'G26NNWKJUPSTGVLLDHCUQ7LFJHMZP2UUAQG2HURLI6LOEI235YCQUNPQEI',
    );

    final response = await algorand
        .indexer()
        .transactions()
        .whereAddress(address)
        .whereAssetId(408947)
        .whereAddressRole(AddressRole.RECEIVER)
        .search();

    print(response.toJson());
  } on AlgorandException catch (ex) {
    final error = ex.cause as DioError;
    print(error.response?.toString());
  }
}

Future searchTransactions({
  required Algorand algorand,
  required Account account,
}) async {
  try {
    final response = await algorand
        .indexer()
        .transactions()
        .whereCurrencyIsGreaterThan(10)
        .search(limit: 2);

    print(response.toJson());
  } on AlgorandException catch (ex) {
    final error = ex.cause as DioError;
    print(error.response?.toString());
  }
}

Future searchTransactionsWithNote({
  required Algorand algorand,
  required Account account,
}) async {
  try {
    final response = await algorand
        .indexer()
        .transactions()
        .afterMinRound(10894697)
        .beforeMaxRound(10994697)
        .whereNotePrefix('showing prefix')
        .search(limit: 2);

    print(response.toJson());
  } on AlgorandException catch (ex) {
    final error = ex.cause as DioError;
    print(error.response?.toString());
  }
}

Future searchTransactionsPaging({
  required Algorand algorand,
  required Account account,
}) async {
  var numtx = 1;
  var nextToken = '';
  while (numtx > 0) {
    final minAmount = 500000000000;
    final limit = 4;
    var nextPage = nextToken;

    try {
      final response = await algorand
          .indexer()
          .transactions()
          .next(nextPage)
          .whereCurrencyIsGreaterThan(minAmount)
          .beforeMaxRound(30000)
          .search(limit: limit);

      numtx = response.transactions.length;
      if (numtx > 0) {
        nextToken = response.nextToken ?? '';
      }
      print(response.toJson());
    } on AlgorandException catch (ex) {
      final error = ex.cause as DioError;
      print(error.response?.toString());
    }
  }
}

Future searchTxAddressAsset({
  required Algorand algorand,
  required Account account,
}) async {
  try {
    final address = Address.fromAlgorandAddress(
      address: 'AMF3CVE4MFZM24CCFEWRCOCWW7TEDJQS3O26OUBRHZ3KWKUBE5ZJRNZ3OY',
    );

    final response = await algorand
        .indexer()
        .transactions()
        .whereAddress(address)
        .whereCurrencyIsGreaterThan(5)
        .whereAssetId(12215366)
        .whereNotePrefix('showing prefix')
        .search(limit: 2);

    print(response.toJson());
  } on AlgorandException catch (ex) {
    final error = ex.cause as DioError;
    print(error.response?.toString());
  }
}

Future searchTxAddressBlock({
  required Algorand algorand,
  required Account account,
}) async {
  try {
    final address = Address.fromAlgorandAddress(
      address: 'NI2EDLP2KZYH6XYLCEZSI5SSO2TFBYY3ZQ5YQENYAGJFGXN4AFHPTR3LXU',
    );

    final response = await algorand
        .indexer()
        .transactions()
        .whereAddress(address)
        .whereRound(8965633)
        .search(limit: 2);

    print(response.toJson());
  } on AlgorandException catch (ex) {
    final error = ex.cause as DioError;
    print(error.response?.toString());
  }
}

Future searchTxAddressTime({
  required Algorand algorand,
  required Account account,
}) async {
  try {
    final address = Address.fromAlgorandAddress(
      address: 'RBSTLLHK2NJDL3ZH66MKSEX3BE2OWQ43EUM7S7YRVBJ2PRDRCKBSDD3YD4',
    );

    final response = await algorand
        .indexer()
        .transactions()
        .whereAddress(address)
        .before(DateTime.now())
        .search(limit: 2);

    print(response.toJson());
  } on AlgorandException catch (ex) {
    final error = ex.cause as DioError;
    print(error.response?.toString());
  }
}

Future searchTransactionWithType({
  required Algorand algorand,
  required Account account,
}) async {
  try {
    final response = await algorand
        .indexer()
        .transactions()
        .whereTransactionType(TransactionType.PAYMENT)
        .search(limit: 2);

    print(response.toJson());
  } on AlgorandException catch (ex) {
    final error = ex.cause as DioError;
    print(error.response?.toString());
  }
}
