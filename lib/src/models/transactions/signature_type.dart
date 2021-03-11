import 'package:json_annotation/json_annotation.dart';

enum SignatureType {
  @JsonValue('sig')
  STANDARD,
  @JsonValue('msig')
  MULTI,
  @JsonValue('lsig')
  LOGIC,
}

extension SignatureTypeExtension on SignatureType {
  String get value {
    switch (this) {
      case SignatureType.STANDARD:
        return 'sig';
      case SignatureType.MULTI:
        return 'msig';
      case SignatureType.LOGIC:
        return 'lsig';
    }
  }
}
