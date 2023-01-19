import 'package:json_annotation/json_annotation.dart';

enum AccountType {
  @JsonValue('single')
  single,
  @JsonValue('multisig')
  multisig,
  @JsonValue('watch')
  watch,
  @JsonValue('contact')
  contact,
  @JsonValue('ledger')
  ledger,
}
