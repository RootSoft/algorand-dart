import 'package:algorand_dart/src/api/responses.dart';
import 'package:algorand_dart/src/repositories/repositories.dart';

class ApplicationManager {
  /// Repository used to perform transaction related tasks.
  final ApplicationRepository applicationRepository;

  ApplicationManager({
    required this.applicationRepository,
  });

  /// Compile TEAL source code to binary, produce its hash
  ///
  /// Given TEAL source code in plain text, return base64 encoded program bytes
  /// and base32 SHA512_256 hash of program bytes (Address style).
  ///
  /// This endpoint is only enabled when a node's configuration file sets EnableDeveloperAPI to true.
  Future<TealCompilation> compileTEAL(String sourceCode) async {
    return await applicationRepository.compileTEAL(sourceCode);
  }
}
