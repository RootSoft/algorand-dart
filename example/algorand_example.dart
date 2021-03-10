import 'package:algorand_dart/src/algorand.dart';
import 'package:algorand_dart/src/clients/algod_client.dart';
import 'package:algorand_dart/src/clients/indexer_client.dart';
import 'package:algorand_dart/src/clients/pure_stake.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/models/transactions/builders/transaction_builders.dart';
import 'package:algorand_dart/src/utils/algo_unit.dart';
import 'package:convert/convert.dart';

void main() async {
  /// Test credentials on TestNet
  final mnemonic =
      'rule stereo half prize arrest explain just coyote olympic phone moon roast benefit hill crush debate reopen frost gasp fatal athlete surge area abandon clump';
  final encodedAddress =
      'RQM43TQH4CHTOXKPLDWVH4FUZQVOWYHRXATHJSQLF7GN6CFFLC35FLNYHM';
  final encodedAddressCs =
      'RQM43TQH4CHTOXKPLDWVH4FUZQVOWYHRXATHJSQLF7GN6CFFLC3QRJKYW4';
  final publicKeyHex =
      '8c19cdce07e08f375d4f58ed53f0b4cc2aeb60f1b82674ca0b2fccdf08a558b7';
  final privateKeyHex =
      'e965f5d0b43a06422daf31d2e4281fb19b8aaea14638b35d57c0381507696b01325156033e09477beed73a485044d8d6ba6a708e17356826c6d9e6247fe9bfc2';

  final apiKey = '';
  final algodClient = new AlgodClient(
    apiUrl: PureStake.TESTNET_ALGOD_API_URL,
    apiKey: apiKey,
    tokenKey: PureStake.API_TOKEN_HEADER,
  );

  final indexerClient = new IndexerClient(
    apiUrl: PureStake.TESTNET_INDEXER_API_URL,
    apiKey: apiKey,
    tokenKey: PureStake.API_TOKEN_HEADER,
  );

  final algorand = new Algorand(
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

  final transactionId = await algorand.sendPayment(
    account: account,
    recipient: newAccount.address,
    amount: Algo.toMicroAlgos(0.5),
  );

  // FlutterCoin - 14618993
}

Future<String> atomicTransfer(
    Algorand algorand, Account accountA, Account accountB) async {
  // Fetch the suggested transaction params
  final params = await algorand.getSuggestedTransactionParams();

  // Build the transaction
  final transactionA = await (PaymentTransactionBuilder()
        ..sender = accountA.address
        ..note = 'Atomic transfer from account A to account B'
        ..amount = Algo.toMicroAlgos(1.2)
        ..receiver = accountB.address
        ..suggestedParams = params)
      .build();

  final transactionB = await (PaymentTransactionBuilder()
        ..sender = accountB.address
        ..note = 'Atomic transfer from account B to account A'
        ..amount = Algo.toMicroAlgos(2)
        ..receiver = accountA.address
        ..suggestedParams = params)
      .build();

  // Combine the transactions and calculate the group id
  final transactions = AtomicTransfer.group([transactionA, transactionB]);

  // Sign the transactions
  final signedTxA = await transactionA.sign(accountA);
  final signedTxB = await transactionB.sign(accountB);

  // Send the transactions
  return await algorand.sendTransactions([signedTxA, signedTxB]);
}
