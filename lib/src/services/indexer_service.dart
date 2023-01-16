import 'package:algorand_dart/algorand_dart.dart';
import 'package:algorand_dart/src/services/api_service.dart';
import 'package:dio/dio.dart' as dio;

part 'indexer_service_impl.dart';

//@RestApi()
abstract class IndexerService extends ApiService {
  factory IndexerService(dio.Dio dio, {String baseUrl}) = _IndexerService;

  //@GET("/health")
  Future<IndexerHealth> health();

  //@GET("/v2/transactions")
  Future<SearchTransactionsResponse> searchTransactions(
    Map<String, dynamic> queryParameters,
  );

  //@GET("/v2/accounts/{accountId}/transactions")
  Future<SearchTransactionsResponse> searchTransactionsForAccount(
    /*@Path('accountId')*/ String accountId,
    Map<String, dynamic> queryParameters,
  );

  //@GET("/v2/assets/{assetId}/transactions")
  Future<SearchTransactionsResponse> searchTransactionsForAsset(
    /*@Path('assetId')*/ int assetId,
    Map<String, dynamic> queryParameters,
  );

  //@GET("/v2/transactions/{transactionId}")
  Future<TransactionResponse> getTransactionById(
    /*@Path('transactionId')*/ String transactionId,
  );
}
