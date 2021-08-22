import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/algorand.dart';
import 'package:algorand_dart/src/clients/algod_client.dart';
import 'package:algorand_dart/src/clients/indexer_client.dart';
import 'package:algorand_dart/src/clients/providers.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/transaction_builders.dart';
import 'package:algorand_dart/src/utils/algo_unit.dart';
import 'package:convert/convert.dart';

void main() async {
  final apiKey = '';
  final algodClient = AlgodClient(
    apiUrl: PureStake.TESTNET_ALGOD_API_URL,
    apiKey: apiKey,
    tokenKey: PureStake.API_TOKEN_HEADER,
  );

  final indexerClient = IndexerClient(
    apiUrl: PureStake.TESTNET_INDEXER_API_URL,
    apiKey: apiKey,
    tokenKey: PureStake.API_TOKEN_HEADER,
  );

  final algorand = Algorand(
    algodClient: algodClient,
    indexerClient: indexerClient,
  );

  // Account A - RQM43TQH4CHTOXKPLDWVH4FUZQVOWYHRXATHJSQLF7GN6CFFLC35FLNYHM
  final seed = hex.decode(
      'e965f5d0b43a06422daf31d2e4281fb19b8aaea14638b35d57c0381507696b01');

  // Account B - 4JHXQUOMJFITR2P656OQYPOJSDVEAAZRJMAEULIURXTWM6LLOXN4NECFDM
  final seed2 = hex.decode(
      '367ab0ceb956fa1e80b39bb04d055190bc3915b10434f68c6efd2aad95ce41f9');

  // Load the accounts
  final account = await algorand.loadAccountFromSeed(seed);
  final newAccount = await algorand.loadAccountFromSeed(seed2);

  // FlutterCoin - 14618993
  final transactionId = await algorand.sendPayment(
    account: account,
    recipient: newAccount.address,
    amount: Algo.toMicroAlgos(5),
  );
  print(transactionId);
}

Future<String> atomicTransfer(
    Algorand algorand, Account accountA, Account accountB) async {
  // Fetch the suggested transaction params
  final params = await algorand.getSuggestedTransactionParams();

  // Build the transaction
  final transactionA = await (PaymentTransactionBuilder()
        ..sender = accountA.address
        ..noteText = 'Atomic transfer from account A to account B'
        ..amount = Algo.toMicroAlgos(1.2)
        ..receiver = accountB.address
        ..suggestedParams = params)
      .build();

  final transactionB = await (PaymentTransactionBuilder()
        ..sender = accountB.address
        ..noteText = 'Atomic transfer from account B to account A'
        ..amount = Algo.toMicroAlgos(2)
        ..receiver = accountA.address
        ..suggestedParams = params)
      .build();

  // Combine the transactions and calculate the group id
  AtomicTransfer.group([transactionA, transactionB]);

  // Sign the transactions
  final signedTxA = await transactionA.sign(accountA);
  final signedTxB = await transactionB.sign(accountB);

  // Send the transactions
  return await algorand.sendTransactions([signedTxA, signedTxB]);
}
