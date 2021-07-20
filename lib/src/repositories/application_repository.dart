import 'package:algorand_dart/src/api/responses.dart';
import 'package:algorand_dart/src/exceptions/algorand_exception.dart';
import 'package:algorand_dart/src/models/models.dart';
import 'package:algorand_dart/src/services/services.dart';
import 'package:dio/dio.dart';

class ApplicationRepository {
  final ApplicationService applicationService;

  ApplicationRepository({
    required this.applicationService,
  });

  /// Compile TEAL source code to binary, produce its hash
  ///
  /// Given TEAL source code in plain text, return base64 encoded program bytes
  /// and base32 SHA512_256 hash of program bytes (Address style).
  ///
  /// This endpoint is only enabled when a node's configuration file sets
  /// EnableDeveloperAPI to true.
  Future<TealCompilation> compileTEAL(String sourceCode) async {
    try {
      return await applicationService.compileTEAL(sourceCode);
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }

  /// Executes TEAL program(s) in context and returns debugging information
  /// about the execution.
  /// This endpoint is only enabled when a node's configuration file sets
  /// EnableDeveloperAPI to true.
  /// /v2/teal/dryrun
  Future<DryRunResponse> dryrun(DryRunRequest request) async {
    try {
      return await applicationService.dryrun(request.toMessagePack());
    } on DioError catch (ex) {
      throw AlgorandException(message: ex.message, cause: ex);
    }
  }
}
