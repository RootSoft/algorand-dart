import 'package:algorand_dart/src/api/api.dart';
import 'package:algorand_dart/src/api/responses/applications/application_logs_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'application_indexer_service.g.dart';

@RestApi()
abstract class ApplicationIndexerService {
  factory ApplicationIndexerService(Dio dio, {String baseUrl}) =
      _ApplicationIndexerService;

  @GET('/v2/accounts/{accountId}/created-applications')
  Future<ApplicationsResponse> getApplicationsByAccount({
    @Path('accountId') required String address,
    @Query('application-id') int? applicationId,
    @Query('include-all') bool? includeAll,
    @Query('limit') int? limit,
    @Query('next') String? next,
    @CancelRequest() CancelToken? cancelToken,
    @SendProgress() ProgressCallback? onSendProgress,
    @ReceiveProgress() ProgressCallback? onReceiveProgress,
  });

  @GET('/v2/applications/{applicationId}')
  Future<ApplicationResponse> getApplicationById({
    @Path('applicationId') required int applicationId,
    @Query('include-all') bool? includeAll,
    @CancelRequest() CancelToken? cancelToken,
    @SendProgress() ProgressCallback? onSendProgress,
    @ReceiveProgress() ProgressCallback? onReceiveProgress,
  });

  @GET('/v2/applications/{applicationId}/logs')
  Future<ApplicationLogsResponse> getApplicationLogsById({
    @Path('applicationId') required int applicationId,
    @Query('limit') int? limit,
    @Query('max-round') int? maxRound,
    @Query('min-round') int? minRound,
    @Query('next') String? next,
    @Query('sender-address') String? senderAddress,
    @Query('txid') String? transactionId,
    @CancelRequest() CancelToken? cancelToken,
    @SendProgress() ProgressCallback? onSendProgress,
    @ReceiveProgress() ProgressCallback? onReceiveProgress,
  });
}
