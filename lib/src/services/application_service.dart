import 'dart:typed_data';

import 'package:algorand_dart/src/api/responses.dart';
import 'package:algorand_dart/src/api/responses/applications/application_logs_response.dart';
import 'package:algorand_dart/src/services/api_service.dart';
import 'package:dio/dio.dart' as dio;

part 'application_service_impl.dart';

//@RestApi()
abstract class ApplicationService extends ApiService {
  factory ApplicationService(dio.Dio dio, {String baseUrl}) =
      _ApplicationService;

  //@POST("/v2/teal/compile")
  //@Headers(<String, dynamic>{"Content-Type": "application/x-binary"})
  //Note stream not needed!?
  Future<TealCompilation> compileTEAL(/*@Body()*/ String sourceCode);

  //@POST("/v2/teal/dryrun")
  //@Headers(<String, dynamic>{"Content-Type": "application/x-binary"})
  Future<DryRunResponse> dryrun(/*@Body()*/ Uint8List request);

  //@GET("/v2/applications")
  Future<SearchApplicationsResponse> searchApplications(
    Map<String, dynamic> queryParameters,
  );

  //@GET("/v2/applications/{applicationId}")
  Future<ApplicationResponse> getApplicationById(
      /*@Path('applicationId')*/ int applicationId);

  //@GET("/v2/applications/{applicationId}")
  Future<ApplicationLogsResponse> getApplicationLogsById(
    /*@Path('applicationId')*/ int applicationId, {
    required Map<String, dynamic> queryParameters,
  });
}
