<p align="center"> 
<img src="https://miro.medium.com/max/700/1*BFpFCJepifaREIg7qLSLag.jpeg">
</p>

# algorand-dart
[![pub.dev][pub-dev-shield]][pub-dev-url]
[![Effective Dart][effective-dart-shield]][effective-dart-url]
[![Stars][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

Algorand is a public blockchain and protocol that aims to deliver decentralization, scale and security for all participants.
Their PURE PROOF OF STAKE™ consensus mechanism ensures full participation, protection, and speed within a truly decentralized network. With blocks finalized in seconds, Algorand’s transaction throughput is on par with large payment and financial networks. And Algorand is the first blockchain to provide immediate transaction finality. No forking. No uncertainty.

## Introduction
Algorand-dart is a community SDK with an elegant approach to connect your Dart & Flutter applications to the Algorand blockchain, send transactions, create assets and query the indexer with just a few lines of code.

Once installed, you can simply connect your application to the blockchain and start sending payments

```dart
algorand.sendPayment(
    account: account,
    recipient: newAccount.address,
    amount: Algo.toMicroAlgos(5),
);
```

or create a new asset:

```dart
algorand.assetManager.createAsset(
    account: account,
    assetName: 'FlutterCoin',
    unitName: 'Flutter',
    totalAssets: 10000,
    decimals: 2,
);
```

## Features
* Algod
* Indexer
* KMD
* AVM 1.0 & TEAL v5 support
* Transactions
* Authorization
* Atomic Transfers
* Account management
* Asset management
* Smart Contracts
* Flutter 2.0 support :heart:

## Getting started

### Installation

You can install the package via pub.dev:

```bash
algorand_dart: ^latest-version
```

> **Note**: Algorand-dart requires Dart >=2.12.0 & null safety
> See the latest version on pub.dev

## Usage
Create an ```AlgodClient```, ```IndexerClient``` and ```KmdClient``` and pass them to the ```Algorand``` constructor.
We added extra support for locally hosted nodes & third party services (like PureStake).

```dart
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

final kmdClient = KmdClient(
    apiUrl: '127.0.0.1',
    apiKey: apiKey,
);

final algorand = Algorand(
    algodClient: algodClient,
    indexerClient: indexerClient,
    kmdClient: kmdClient,
);
```

## Ecosystem integrations

* [AlgoSigner](https://pub.dev/packages/flutter_algosigner) - A Flutter web plugin to approve or deny Algorand transactions from within your browser using AlgoSigner.
* [MyAlgo Connect](https://pub.dev/packages/flutter_myalgo_connect) - A Flutter web plugin to approve or deny Algorand transactions using MyAlgo Connect.
* [WalletConnect](https://pub.dev/packages/walletconnect_dart) - Open protocol for connecting decentralised applications to mobile wallets with QR code scanning or deep linking.

## Account Management
Accounts are entities on the Algorand blockchain associated with specific onchain data, like a balance. An Algorand Address is the identifier for an Algorand account.

### Creating a new account

Creating a new account is as easy as calling:
```dart
final account = await algorand.createAccount();
```

Or you can always use the ```Account``` class.
```dart
final account = await Account.random();
```

With the given account, you can easily extract the public Algorand address, signing keys and seedphrase/mnemonic.
```dart
final publicAddress = account.publicAddress;
final words = await account.seedPhrase;
```

### Loading an existing account

You can load an existing account using your **generated secret key or binary seed**.

```dart
final account = await algorand.loadAccountFromSeed(seed);
```

### Restoring an account

Recovering an account from your 25-word mnemonic/seedphrase can be done by passing an **array or space delimited string**

```dart
final restoredAccount = await algorand.restoreAccount([/* 25 words */]);
```

## Transactions
There are multiple ways to create a transaction. We've included helper functions to make our life easier.

```dart
algorand.sendPayment(
    account: account,
    recipient: newAccount.address,
    amount: Algo.toMicroAlgos(5),
    note: 'Hi from Flutter!',
);
```

This will broadcast the transaction and immediately returns the transaction id, however you can also wait until the transaction is confirmed in a block using:

```dart
final transactionId = await algorand.sendPayment(
    account: account,
    recipient: newAccount.address,
    amount: Algo.toMicroAlgos(5),
    note: 'Hi from Flutter!',
    waitForConfirmation: true,
    timeout: 3,
);
```


Or you can use the ```TransactionBuilder``` to create more specific, raw transactions:

```dart
// Fetch the suggested transaction params
final params = await algorand.getSuggestedTransactionParams();

// Build the transaction
final transaction = await (PaymentTransactionBuilder()
    ..sender = account.address
    ..note = 'Hi from Flutter'
    ..amount = Algo.toMicroAlgos(5)
    ..receiver = recipient
    ..suggestedParams = params)
  .build();

// Sign the transaction
final signedTx = await transaction.sign(account);

// Send the transaction
final txId = await algorand.sendTransaction(signedTx);
```

## Atomic Transfer
An Atomic Transfer means that transactions that are part of the transfer either all succeed or all fail.
Atomic transfers allow complete strangers to trade assets without the need for a trusted intermediary,
all while guaranteeing that each party will receive what they agreed to.

Atomic transfers enable use cases such as:

* **Circular trades** - Alice pays Bob if and only if Bob pays Claire if and only if Claire pays Alice.
* **Group payments** - Everyone pays or no one pays.
* **Decentralized exchanges** - Trade one asset for another without going through a centralized exchange.
* **Distributed payments** - Payments to multiple recipients.

An atomic transfer can be created as following:

```dart
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
AtomicTransfer.group([transactionA, transactionB]);

// Sign the transactions
final signedTxA = await transactionA.sign(accountA);
final signedTxB = await transactionB.sign(accountB);

// Send the transactions
final txId = await algorand.sendTransactions([signedTxA, signedTxB]);
```

## Asset Management

**Create a new asset**

Creating a new asset is as simple as using the ```AssetManager``` included in the Algorand SDK:

```dart
final transactionId = await algorand.assetManager.createAsset(
    account: account,
    assetName: 'FlutterCoin',
    unitName: 'Flutter',
    totalAssets: 10000,
    decimals: 2,
);
```

Or as usual, you can use the ```TransactionBuilder``` to create your asset:

```dart
// Fetch the suggested transaction params
final params = await algorand.getSuggestedTransactionParams();

final transaction = await (AssetConfigTransactionBuilder()
      ..assetName = 'FlutterCoin'
      ..unitName = 'Flutter'
      ..totalAssetsToCreate = 10000
      ..decimals = 2
      ..defaultFrozen = false
      ..managerAddress = account.address
      ..reserveAddress = account.address
      ..freezeAddress = account.address
      ..clawbackAddress = account.address
      ..sender = account.address
      ..suggestedParams = params)
    .build();

// Sign the transactions
final signedTransaction = await transaction.sign(account);

// Send the transaction
final txId = await algorand.sendTransaction(signedTransaction);
```

**Edit an asset**

After an asset has been created only the manager, reserve, freeze and clawback accounts can be changed.
All other parameters are locked for the life of the asset.

If any of these addresses are set to "" that address will be cleared and can never be reset for the life of the asset.
Only the manager account can make configuration changes and must authorize the transaction.

```dart
algorand.assetManager.editAsset(
    assetId: 14618993,
    account: account,
    managerAddress: account.address,
    reserveAddress: account.address,
    freezeAddress: account.address,
    clawbackAddress: account.address,
);
```

**Destroy an asset**

```dart
algorand.assetManager.destroyAsset(assetId: 14618993, account: account);
```

**Opt in to receive an asset**

Before being able to receive an asset, you should opt in
An opt-in transaction is simply an asset transfer with an amount of 0, both to and from the account opting in.
Assets can be transferred between accounts that have opted-in to receiving the asset.

```dart
algorand.assetManager.optIn(assetId: 14618993, account: account);
```

**Transfer an asset**

Transfer an asset from the account to the receiver.
Assets can be transferred between accounts that have opted-in to receiving the asset.
These are analogous to standard payment transactions but for Algorand Standard Assets.

```dart
algorand.assetManager.transfer(assetId: 14618993, account: account, receiver: receiver, amount: 1000);
```

**Freeze an asset**

Freezing or unfreezing an asset requires a transaction that is signed by the freeze account.

Upon creation of an asset, you can specify a freeze address and a defaultfrozen state.
If the defaultfrozen state is set to true the corresponding freeze address must issue unfreeze transactions,
to allow trading of the asset to and from that account.
This may be useful in situations that require holders of the asset to pass certain checks prior to ownership.

```dart
algorand.assetManager.freeze(
    assetId: 14618993,
    account: account,
    freezeTarget:
    newAccount.address,
    freeze: true,
)
```

**Revoking an asset**

Revoking an asset for an account removes a specific number of the asset from the revoke target account.
Revoking an asset from an account requires specifying an asset sender (the revoke target account) and an
asset receiver (the account to transfer the funds back to).

```dart
algorand.assetManager.revoke(
    assetId: 14618993,
    account: account,
    amount: 1000,
    revokeAddress: account.address,
  );
```

## Stateless Smart Contracts

Most Algorand transactions are authorized by a signature from a single account or a multisignature account.
Algorand’s stateful smart contracts allow for a third type of signature using a
Transaction Execution Approval Language (TEAL) program, called a logic signature (LogicSig).
Stateless smart contracts provide two modes for TEAL logic to operate as a LogicSig,
to create a contract account that functions similar to an escrow or to delegate signature authority to another account.

### Contract Account

Contract accounts are great for setting up escrow style accounts where you want to limit withdrawals or you want to do periodic payments, etc.
To spend from a contract account, create a transaction that will evaluate to True against the TEAL logic,
then add the compiled TEAL code as its logic signature.
It is worth noting that anyone can create and submit the transaction that spends from a contract account as long as they have the compiled TEAL contract to add as a logic signature.

Sample teal file
```teal
// samplearg.teal
// This code is meant for learning purposes only
// It should not be used in production
arg_0
btoi
int 123
==
```

```dart
final arguments = <Uint8List>[];
arguments.add(Uint8List.fromList([123]));

final result =
    await algorand.applicationManager.compileTEAL(sampleArgsTeal);
final logicSig = LogicSignature.fromProgram(
  program: result.program,
  arguments: arguments,
);

final receiver =
    'KTFZ5SQU3AQ6UFYI2QOWF5X5XJTAFRHACWHXAZV6CPLNKS2KSGQWPT4ACE';
final params = await algorand.getSuggestedTransactionParams();
final transaction = await (PaymentTransactionBuilder()
      ..sender = logicSig.toAddress()
      ..note = 'Logic Signature'
      ..amount = 100000
      ..receiver = Address.fromAlgorandAddress(address: receiver)
      ..suggestedParams = params)
    .build();

// Sign the logic transaction
final signedTx = await logicSig.signTransaction(transaction: transaction);

// Send the transaction
final txId = await algorand.sendTransaction(
  signedTx,
  waitForConfirmation: true,
);
```

### Account Delegation

Stateless smart contracts can also be used to delegate signatures, which means that a private key can sign a TEAL program
and the resulting output can be used as a signature in transactions on behalf of the account associated with the private key.
The owner of the delegated account can share this logic signature, allowing anyone to spend funds from his or her account according to the logic within the TEAL program.

```dart
final arguments = <Uint8List>[];
arguments.add(Uint8List.fromList([123]));

final result =
    await algorand.applicationManager.compileTEAL(sampleArgsTeal);
final logicSig = await LogicSignature.fromProgram(
  program: result.program,
  arguments: arguments,
).sign(account: account);

final receiver =
    'KTFZ5SQU3AQ6UFYI2QOWF5X5XJTAFRHACWHXAZV6CPLNKS2KSGQWPT4ACE';
final params = await algorand.getSuggestedTransactionParams();
final transaction = await (PaymentTransactionBuilder()
      ..sender = account.address
      ..note = 'Account delegation'
      ..amount = 100000
      ..receiver = Address.fromAlgorandAddress(address: receiver)
      ..suggestedParams = params)
    .build();

// Sign the logic transaction
final signedTx = await logicSig.signTransaction(transaction: transaction);

// Send the transaction
final txId = await algorand.sendTransaction(
  signedTx,
  waitForConfirmation: true,
);
```

## Stateful Smart Contracts
Stateful smart contracts are contracts that live on the chain and are used to keep track of some form of global and/or local state for the contract.
Stateful smart contracts form the backbone of applications that intend to run on the Algorand blockchain. Stateful smart contracts act similar to Algorand ASAs in that they have specific global values and per-user values.

**Create a new application**

Before creating a stateful smart contract, the code for the ApprovalProgram and the ClearStateProgram program should be written.
The creator is the account that is creating the application and this transaction is signed by this account.
The approval program and the clear state program should also be provided.
The number of global and local byte slices (byte-array value) and integers also needs to be specified.
These represent the absolute on-chain amount of space that the smart contract will use.
Once set, these values can never be changed.

When the smart contract is created the network will return a unique ApplicationID.
This ID can then be used to make ApplicationCall transactions to the smart contract.

```dart
// declare application state storage (immutable)
final localInts = 1;
final localBytes = 1;
final globalInts = 1;
final globalBytes = 0;

final txId = await algorand.applicationManager.createApplicationFromSource(
  account: account,
  approvalProgramSource: approvalProgramSource,
  clearProgramSource: clearProgramSource,
  globalStateSchema: StateSchema(
    numUint: globalInts,
    numByteSlice: globalBytes,
  ),
  localStateSchema: StateSchema(
    numUint: localInts,
    numByteSlice: localBytes,
  ),
);
```

Or you can build the raw transaction using the ```ApplicationCreateTransactionBuilder```.

```dart
// declare application state storage (immutable)
final localInts = 1;
final localBytes = 1;
final globalInts = 1;
final globalBytes = 0;

final approvalProgram =
    await algorand.applicationManager.compileTEAL(approvalProgramSource);

final clearProgram =
    await algorand.applicationManager.compileTEAL(clearProgramSource);

final params = await algorand.getSuggestedTransactionParams();

final transaction = await (ApplicationCreateTransactionBuilder()
      ..sender = account.address
      ..approvalProgram = approvalProgram.program
      ..clearStateProgram = clearProgram.program
      ..globalStateSchema = StateSchema(
        numUint: globalInts,
        numByteSlice: globalBytes,
      )
      ..localStateSchema = StateSchema(
        numUint: localInts,
        numByteSlice: localBytes,
      )
      ..suggestedParams = params)
    .build();

final signedTx = await transaction.sign(account);
final txId = await algorand.sendTransaction(
  signedTx,
  waitForConfirmation: true,
);
```

**Opt into the Smart Contract**

Before any account, including the creator of the smart contract, can begin to make Application
Transaction calls that use local state, it must first opt into the smart contract.
This prevents accounts from being spammed with smart contracts.
To opt in, an ApplicationCall transaction of type OptIn needs to be signed and submitted by the
account desiring to opt into the smart contract.

```dart
final txId = await algorand.applicationManager.optIn(
  account: account,
  applicationId: 19964146,
);
```

Or you can build the raw transaction using the ```ApplicationOptInTransactionBuilder```.

```
final params = await algorand.getSuggestedTransactionParams();

final transaction = await (ApplicationOptInTransactionBuilder()
      ..sender = account.address
      ..applicationId = 19964146
      ..suggestedParams = params)
    .build();

final signedTx = await transaction.sign(account);
final txId = await algorand.sendTransaction(
  signedTx,
  waitForConfirmation: true,
);
```

**Calling a Stateful Smart Contract**

Once an account has opted into a stateful smart contract it can begin to make calls to the contract.
Depending on the individual type of transaction as described in The Lifecycle of a Stateful Smart
Contract, either the ApprovalProgram or the ClearStateProgram will be called.
Generally, individual calls will supply application arguments.
See [Passing Arguments to a Smart Contract](https://developer.algorand.org/docs/features/asc1/stateful/#passing-arguments-to-stateful-smart-contracts) for details on passing arguments.

```dart
final txId = algorand.applicationManager.call(
  account: account,
  applicationId: 19964146,
  arguments: arguments,
);
```

Or you can build the raw transaction using the ```ApplicationCallTransactionBuilder```.

```dart
final arguments = 'str:arg1,int:12'.toApplicationArguments();
final params = await algorand.getSuggestedTransactionParams();

final transaction = await (ApplicationCallTransactionBuilder()
      ..sender = account.address
      ..applicationId = 19964146
      ..arguments = arguments
      ..suggestedParams = params)
    .build();

final signedTx = await transaction.sign(account);
final txId = await algorand.sendTransaction(
  signedTx,
  waitForConfirmation: true,
);
```

**Update a Stateful Smart Contract**

A stateful smart contract’s programs can be updated at any time.
This is done by an ApplicationCall transaction type of UpdateApplication.
This operation requires passing the new programs and specifying the application ID.
The one caveat to this operation is that global or local state requirements for the smart contract can never be updated.

```dart
final approvalProgram =
    await algorand.applicationManager.compileTEAL(approvalProgramSource);

final clearProgram =
    await algorand.applicationManager.compileTEAL(clearProgramSource);

final txId = await algorand.applicationManager.update(
  account: account,
  applicationId: 19964146,
  approvalProgram: approvalProgram.program,
  clearProgram: clearProgram.program,
);
```

Or you can build the raw transaction using the ```ApplicationUpdateTransactionBuilder```.

```dart
final approvalProgram =
    await algorand.applicationManager.compileTEAL(approvalProgramSource);

final clearProgram =
    await algorand.applicationManager.compileTEAL(clearProgramSource);

final params = await algorand.getSuggestedTransactionParams();

final transaction = await (ApplicationUpdateTransactionBuilder()
      ..sender = account.address
      ..applicationId = 19964146
      ..approvalProgram = approvalProgram.program
      ..clearStateProgram = clearProgram.program
      ..suggestedParams = params)
    .build();

final signedTx = await transaction.sign(account);
final txId = await algorand.sendTransaction(
  signedTx,
  waitForConfirmation: true,
);
```

**Delete a Stateful Smart Contract**

To delete a smart contract, an ApplicationCall transaction of type DeleteApplication must be submitted to the blockchain.
The ApprovalProgram handles this transaction type and if the call returns true the application will be deleted.

```
final txId = await algorand.applicationManager.delete(
  account: account,
  applicationId: 19964146,
);
```

**Close out**

The user may discontinue use of the application by sending a close out transaction. This will remove the local state for this application from the user's account

```dart
final txId = await algorand.applicationManager.close(
  account: account,
  applicationId: 19964146,
);
```

**Clear state**

The user may clear the local state for an application at any time, even if the application was deleted by the creator. This method uses the same 3 parameter.

```dart
final txId = await algorand.applicationManager.clearState(
  account: account,
  applicationId: 19964146,
);
```

## Multi Signatures
Multisignature accounts are a logical representation of an ordered set of addresses with a threshold and version.
Multisignature accounts can perform the same operations as other accounts, including sending transactions and participating in consensus.
The address for a multisignature account is essentially a hash of the ordered list of accounts, the threshold and version values.
The threshold determines how many signatures are required to process any transaction from this multisignature account.

**Create a multisignature address**

```dart
final one = Address.fromAlgorandAddress(
  address: 'XMHLMNAVJIMAW2RHJXLXKKK4G3J3U6VONNO3BTAQYVDC3MHTGDP3J5OCRU',
);
final two = Address.fromAlgorandAddress(
  address: 'HTNOX33OCQI2JCOLZ2IRM3BC2WZ6JUILSLEORBPFI6W7GU5Q4ZW6LINHLA',
);

final three = Address.fromAlgorandAddress(
  address: 'E6JSNTY4PVCY3IRZ6XEDHEO6VIHCQ5KGXCIQKFQCMB2N6HXRY4IB43VSHI',
);

final publicKeys = [one, two, three]
    .map((address) => Ed25519PublicKey(bytes: address.publicKey))
    .toList();

final multiSigAddr =
    MultiSigAddress(version: 1, threshold: 2, publicKeys: publicKeys);
```

**Sign a transaction with a multisignature account**
This section shows how to create, sign, and send a transaction from a multisig account.

```dart
final account1 = await Account.fromSeed(seed1);
final account2 = await Account.fromSeed(seed2);
final account3 = await Account.fromSeed(seed3);

final publicKeys = [account1, account2, account3]
    .map((account) => Ed25519PublicKey(bytes: account.address.publicKey))
    .toList();

final msa =
    MultiSigAddress(version: 1, threshold: 2, publicKeys: publicKeys);

final params = await algorand.getSuggestedTransactionParams();
final transaction = await (PaymentTransactionBuilder()
      ..sender = msa.toAddress()
      ..note = 'MSA '
      ..amount = 1000000
      ..receiver = account3.address
      ..suggestedParams = params)
    .build();

// Sign the transaction with the first account.
final signedTx = await msa.sign(
  account: account1,
  transaction: transaction,
);

final completeTx = await msa.append(
  account: account2,
  transaction: signedTx,
);

// Send the transaction
final txId = await algorand.sendTransaction(
  completeTx,
  waitForConfirmation: true,
);
```

## Key Management Daemon

The Key Management Daemon (kmd) is a low level wallet and key management tool. It works in conjunction with algod and goal to keep secrets safe.
kmd tries to ensure that secret keys never touch the disk unencrypted.

* kmd has a data directory separate from algod's data directory. By default, however, the kmd data directory is in the kmd subdirectory of algod's data directory.
* kmd starts an HTTP API server on localhost:7833 by default.
* You talk to the HTTP API by sending json-serialized request structs from the kmdapi package.

Note: If you are using a third-party API service, this process likely will not be available to you.

```dart
final request = (CreateWalletRequestBuilder()
      ..walletName = 'wallet'
      ..walletPassword = 'test'
      ..walletDriverName = 'sqlite')
    .build();

final response = await algorand.kmd.createWallet(createWalletRequest: request);
```

Check out the [Algorand Developer documentation ](https://developer.algorand.org/docs/features/accounts/create/#wallet-derived-kmd) to learn more about the Key Management Daemon.

## Indexer
Algorand provides a standalone daemon algorand-indexer that reads committed blocks from the Algorand blockchain and
maintains a local database of transactions and accounts that are searchable and indexed.

The Dart SDK makes it really easy to search the ledger in a fluent api and enables application developers to perform rich and efficient queries on accounts,
transactions, assets, and so forth.

At the moment we support queries on transactions, assets and accounts.

### Transactions
Allow searching all transactions that have occurred on the blockchain.

```dart
final transactions = await algorand
  .indexer()
  .transactions()
  .whereCurrencyIsLessThan(Algo.toMicroAlgos(1000))
  .whereCurrencyIsGreaterThan(Algo.toMicroAlgos(500))
  .whereAssetId(14618993)
  .whereNotePrefix('Flutter')
  .whereTransactionType(TransactionType.PAYMENT)
  .search(limit: 5);
```

### Assets
Allow searching all assets that are created on the blockchain.

```dart
final assets = await algorand
  .indexer()
  .assets()
  .whereCurrencyIsLessThan(Algo.toMicroAlgos(1000))
  .whereCurrencyIsGreaterThan(Algo.toMicroAlgos(500))
  .whereAssetId(14618993)
  .whereUnitName('Flutter')
  .whereCreator(account.publicAddress)
  .search(limit: 5);
```
### Accounts
Allow searching all accounts that are created on the blockchain.

```dart
final accounts = await algorand
      .indexer()
      .accounts()
      .whereCurrencyIsLessThan(Algo.toMicroAlgos(1000))
      .whereCurrencyIsGreaterThan(Algo.toMicroAlgos(500))
      .whereAssetId(14618993)
      .whereAuthAddress(account.publicAddress)
      .search(limit: 5);
```

### Applications
Allow searching all applications on the blockchain.

```dart
final applications = await algorand
    .indexer()
    .applications()
    .whereApplicationId(19964146)
    .limit(5)
    .search();
```

## Changelog

Please see [CHANGELOG](CHANGELOG.md) for more information on what has changed recently.

## Contributing & Pull Requests
Feel free to send pull requests.

Please see [CONTRIBUTING](.github/CONTRIBUTING.md) for details.

## Credits

- [Tomas Verhelst](https://github.com/rootsoft)
- [All Contributors](../../contributors)

## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[pub-dev-shield]: https://img.shields.io/pub/v/algorand_dart?style=for-the-badge
[pub-dev-url]: https://pub.dev/packages/algorand_dart
[effective-dart-shield]: https://img.shields.io/badge/style-effective_dart-40c4ff.svg?style=for-the-badge
[effective-dart-url]: https://github.com/tenhobi/effective_dart
[stars-shield]: https://img.shields.io/github/stars/rootsoft/algorand-dart.svg?style=for-the-badge&logo=github&colorB=deeppink&label=stars
[stars-url]: https://packagist.org/packages/rootsoft/algorand-dart
[issues-shield]: https://img.shields.io/github/issues/rootsoft/algorand-dart.svg?style=for-the-badge
[issues-url]: https://github.com/rootsoft/algorand-dart/issues
[license-shield]: https://img.shields.io/github/license/rootsoft/algorand-dart.svg?style=for-the-badge
[license-url]: https://github.com/RootSoft/algorand-dart/blob/master/LICENSE