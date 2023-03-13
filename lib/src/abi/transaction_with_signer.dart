import 'package:algorand_dart/algorand_dart.dart';

class TransactionWithSigner {
  final RawTransaction transaction;
  final TxnSigner signer;

  TransactionWithSigner({
    required this.transaction,
    required this.signer,
  });
}
