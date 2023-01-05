import 'package:algorand_dart/src/api/application/application.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'indexer_application_service.g.dart';

@RestApi()
abstract class IndexerApplicationService {
  factory IndexerApplicationService(Dio dio, {String baseUrl}) =
      _IndexerApplicationService;

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
}
