# algorand_dart

Unofficial community SDK to interact with the Algorand network, in Dart & Flutter

## Getting Started

### Installation

You can install the package via pub.dev:

```bash
algorand_dart: ^latest-version
```

> **Note**: Algorand-dart requires Dart >=2.12.0 & null safety
> See the latest version on pub.dev

## Usage
Create an ```AlgodClient``` and ```IndexerClient``` and pass them to the ```Algorand``` constructor.
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

final algorand = Algorand(
    algodClient: algodClient,
    indexerClient: indexerClient,
);
```

Once installed, you can simply connect your application to the blockchain and start sending payments

```dart
algorand.sendPayment(
    account: account,
    recipient: newAccount.address,
    amount: Algo.toMicroAlgos(5),
);
```
