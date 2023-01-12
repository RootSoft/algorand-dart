import 'package:algorand_dart/src/api/algod/transformers/transformers.dart';
import 'package:algorand_dart/src/api/block/block.dart';

/// A Transformer to transform an encoded block from the algod/node endpoint to
/// the indexer [Block] model.
class BlockTransformer extends AlgodTransformer<AlgodBlock, Block> {
  @override
  Block transform(AlgodBlock input) {
    final transformer = TransactionTransformer(input);
    final transactions = input.transactions.map(transformer.transform).toList();

    final output = Block(
      transactions: transactions,
      genesisHash: input.genesisHash,
      genesisId: input.genesisId,
      previousBlockHash: input.previousBlockHash,
      round: input.round,
      seed: input.seed,
      timestamp: input.timestamp,
      txnCounter: input.txnCounter,
    );

    return output;
  }
}
