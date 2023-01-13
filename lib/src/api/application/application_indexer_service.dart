import 'package:algorand_dart/src/api/application/application.dart';
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
}
