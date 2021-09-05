import 'package:algorand_dart/algorand_dart.dart';

void main() async {
  final algodClient = AlgodClient(
    apiUrl: AlgoExplorer.TESTNET_ALGOD_API_URL,
  );

  final algorand = Algorand(algodClient: algodClient);

  final words1 =
      // ignore: lines_longer_than_80_chars
      'year crumble opinion local grid injury rug happy away castle minimum bitter upon romance federal entire rookie net fabric soft comic trouble business above talent';

  final words2 =
      // ignore: lines_longer_than_80_chars
      'beauty nurse season autumn curve slice cry strategy frozen spy panic hobby strong goose employ review love fee pride enlist friend enroll clip ability runway';

  final words3 =
      // ignore: lines_longer_than_80_chars
      'picnic bright know ticket purity pluck stumble destroy ugly tuna luggage quote frame loan wealth edge carpet drift cinnamon resemble shrimp grain dynamic absorb edge';

  final account1 = await Account.fromSeedPhrase(words1.split(' '));
  final account2 = await Account.fromSeedPhrase(words2.split(' '));
  final account3 = await Account.fromSeedPhrase(words3.split(' '));

  print('Account 1: ${account1.publicAddress}');
  print('Account 2: ${account2.publicAddress}');
  print('Account 3: ${account3.publicAddress}');

  // Create a new asset
  final assetId = await createAsset(
    algorand: algorand,
    sender: account1,
    manager: account2,
  );

  // Update manager address
  await changeManager(
    algorand: algorand,
    sender: account2,
    manager: account1,
    assetId: assetId,
  );

  // Opt in the asset
  await optIn(algorand: algorand, account: account3, assetId: assetId);

  // Transfer the asset
  await transfer(
    algorand: algorand,
    sender: account1,
    receiver: account3,
    assetId: assetId,
  );
}

Future<int> createAsset({
  required Algorand algorand,
  required Account sender,
  required Account manager,
}) async {
  print('--- Creating asset ---');

  // Get the suggested transaction params
  final params = await algorand.getSuggestedTransactionParams();

  // Create the asset
  final tx = await (AssetConfigTransactionBuilder()
        ..sender = sender.address
        ..totalAssetsToCreate = 10000
        ..decimals = 0
        ..unitName = 'myunit'
        ..assetName = 'my longer asset name'
        ..url = 'http://this.test.com'
        ..metadataText = '16efaa3924a6fd9d3a4824799a4ac65d'
        ..defaultFrozen = false
        ..managerAddress = manager.address
        ..reserveAddress = manager.address
        ..freezeAddress = manager.address
        ..clawbackAddress = manager.address
        ..suggestedParams = params)
      .build();

  // Sign the transaction
  final signedTx = await tx.sign(sender);

  // Broadcast the transaction
  final txId = await algorand.sendTransaction(signedTx);
  final response = await algorand.waitForConfirmation(txId);
  final assetId = response.assetIndex ?? 0;

  // Print created asset
  printCreatedAsset(algorand: algorand, account: sender, assetId: assetId);

  // Print asset holding
  printAssetHolding(algorand: algorand, account: sender, assetId: assetId);

  return assetId;
}

Future changeManager({
  required Algorand algorand,
  required Account sender,
  required Account manager,
  required int assetId,
}) async {
  print('--- Changing manager address ---');

  // Get the suggested transaction params
  final params = await algorand.getSuggestedTransactionParams();

  // Create the asset
  final tx = await (AssetConfigTransactionBuilder()
        ..sender = sender.address
        ..assetId = assetId
        ..managerAddress = sender.address
        ..reserveAddress = manager.address
        ..freezeAddress = manager.address
        ..clawbackAddress = manager.address
        ..suggestedParams = params)
      .build();

  // Sign the transaction
  final signedTx = await tx.sign(sender);

  // Broadcast the transaction
  final txId = await algorand.sendTransaction(signedTx);
  final response = await algorand.waitForConfirmation(txId);
  print(response);

  // Print created asset
  printCreatedAsset(algorand: algorand, account: manager, assetId: assetId);

  return Future.value();
}

/// Opt in to receive an asset
Future optIn({
  required Algorand algorand,
  required Account account,
  required int assetId,
}) async {
  print('--- Opting in ---');
  // Get the suggested transaction params
  final params = await algorand.getSuggestedTransactionParams();

  // Opt in to the asset=
  final tx = await (AssetTransferTransactionBuilder()
        ..assetId = assetId
        ..receiver = account.address
        ..sender = account.address
        ..suggestedParams = params)
      .build();

  // Sign the transaction
  final signedTx = await tx.sign(account);

  // Broadcast the transaction
  final txId = await algorand.sendTransaction(signedTx);
  final response = await algorand.waitForConfirmation(txId);
  print(response);

  // Print created asset
  printAssetHolding(algorand: algorand, account: account, assetId: assetId);

  return Future.value();
}

/// Transfer asset from creator to opted in account
Future<bool> transfer({
  required Algorand algorand,
  required Account sender,
  required Account receiver,
  required int assetId,
}) async {
  print('--- Transfering asset ---');

  // Get the suggested transaction params
  final params = await algorand.getSuggestedTransactionParams();

  // Transfer the asset
  final tx = await (AssetTransferTransactionBuilder()
        ..assetId = assetId
        ..sender = sender.address
        ..receiver = receiver.address
        ..amount = 10
        ..suggestedParams = params)
      .build();

  // Sign the transaction
  final signedTx = await tx.sign(sender);

  // Broadcast the transaction
  final txId = await algorand.sendTransaction(signedTx);
  final response = await algorand.waitForConfirmation(txId);
  print(response);

  // Print created asset
  printAssetHolding(algorand: algorand, account: receiver, assetId: assetId);

  printAssetHolding(algorand: algorand, account: sender, assetId: assetId);

  return Future.value(true);
}

void printCreatedAsset({
  required Algorand algorand,
  required Account account,
  required int? assetId,
}) async {
  final information = await algorand.getAccountByAddress(account.publicAddress);
  for (var asset in information.createdAssets) {
    if (asset.index == assetId) {
      print('Created asset: $asset');
      return;
    }
  }
}

void printAssetHolding({
  required Algorand algorand,
  required Account account,
  required int? assetId,
}) async {
  final information = await algorand.getAccountByAddress(account.publicAddress);
  for (var asset in information.assets) {
    if (asset.assetId == assetId) {
      print('Asset holding: $asset');
      return;
    }
  }
}
