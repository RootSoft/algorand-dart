import 'package:algorand_dart/algorand_dart.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'account_indexer_service.g.dart';

@RestApi()
abstract class AccountIndexerService {
  factory AccountIndexerService(Dio dio, {String baseUrl}) =
      _AccountIndexerService;

  @GET('/v2/accounts/{address}')
  Future<AccountResponse> getAccountByAddress({
    @Path('address') required String address,
    @Query('exclude') String? exclude,
    @Query('include-all') bool? includeAll,
    @Query('round') int? round,
    @CancelRequest() CancelToken? cancelToken,
    @SendProgress() ProgressCallback? onSendProgress,
    @ReceiveProgress() ProgressCallback? onReceiveProgress,
  });
}
