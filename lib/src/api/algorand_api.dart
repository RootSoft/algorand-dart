import 'package:algorand_dart/src/api/algod/transformers/algod_transformer.dart';
import 'package:algorand_dart/src/api/paginated_result.dart';
import 'package:algorand_dart/src/exceptions/algorand_exception.dart';
import 'package:dio/dio.dart';

class AlgorandApi {
  Future<T> execute<T>(
    Future<dynamic> Function() callback, {
    AlgodTransformer<dynamic, T>? transformer,
  }) async {
    try {
      final response = await callback();
      if (transformer != null) {
        return transformer.transform(response);
      }

      if (response is! T) {
        throw AlgorandException(message: 'Response does not match');
      }

      return response;
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }

  Future<List<T>> paginate<T>(
    Future<PaginatedResult<T>> Function(String? nextToken) callback,
  ) async {
    final items = <T>[];
    String? nextToken;
    do {
      try {
        final response = await callback(nextToken);

        items.addAll(response.items);
        nextToken = response.nextToken;
      } on DioError catch (ex) {
        throw AlgorandException(message: ex.message, cause: ex);
      }
    } while (nextToken != null);

    return items;
  }
}
