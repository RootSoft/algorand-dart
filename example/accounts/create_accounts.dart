import 'package:algorand_dart/algorand_dart.dart';

void main() async {
  try {
    final account = await Account.random();
    print('My address 1: ${account.publicAddress}');
    print('My passphrase 1: ${await account.seedPhrase}');

    final account2 = await Account.random();
    print('My address 2: ${account2.publicAddress}');
    print('My passphrase 2: ${await account2.seedPhrase}');

    final account3 = await Account.random();
    print('My address 3: ${account3.publicAddress}');
    print('My passphrase 3: ${await account3.seedPhrase}');
  } catch (ex) {
    print(ex);
  }
}
