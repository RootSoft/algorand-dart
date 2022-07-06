import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/transaction/transaction_signer.dart';

class TransactionWithSigner {
  final RawTransaction transaction;
  final TxnSigner signer;

  TransactionWithSigner({
    required this.transaction,
    required this.signer,
  });
}
