import 'package:algorand_dart/src/api/box/box_names_response.dart';
import 'package:algorand_dart/src/api/box/box_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'box_algod_service.g.dart';

@RestApi()
abstract class BoxAlgodService {
  factory BoxAlgodService(Dio dio, {String baseUrl}) = _BoxAlgodService;

  @GET('/v2/applications/{applicationId}/box')
  Future<BoxResponse> getBoxByApplicationId({
    @Path('applicationId') required int applicationId,
    @Query('name') required String name,
    @CancelRequest() CancelToken? cancelToken,
    @SendProgress() ProgressCallback? onSendProgress,
    @ReceiveProgress() ProgressCallback? onReceiveProgress,
  });

  @GET('/v2/applications/{applicationId}/boxes')
  Future<BoxNamesResponse> getBoxNamesByApplicationId({
    @Path('applicationId') required int applicationId,
    @Query('max') int? max,
    @CancelRequest() CancelToken? cancelToken,
    @SendProgress() ProgressCallback? onSendProgress,
    @ReceiveProgress() ProgressCallback? onReceiveProgress,
  });
}
