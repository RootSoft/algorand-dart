import 'package:json_annotation/json_annotation.dart';

enum OnCompletion {
  @JsonValue('noop')
  NO_OP_OC,
  @JsonValue('optin')
  OPT_IN_OC,
  @JsonValue('closeout')
  CLOSE_OUT_OC,
  @JsonValue('clear')
  CLEAR_STATE_OC,
  @JsonValue('update')
  UPDATE_APPLICATION_OC,
  @JsonValue('delete')
  DELETE_APPLICATION_OC,
}

extension OnCompletionExtension on OnCompletion {
  String get name {
    switch (this) {
      case OnCompletion.NO_OP_OC:
        return 'noop';
      case OnCompletion.OPT_IN_OC:
        return 'optin';
      case OnCompletion.CLOSE_OUT_OC:
        return 'closeout';
      case OnCompletion.CLEAR_STATE_OC:
        return 'clearstate';
      case OnCompletion.UPDATE_APPLICATION_OC:
        return 'update';
      case OnCompletion.DELETE_APPLICATION_OC:
        return 'delete';
    }
  }

  int get value {
    switch (this) {
      case OnCompletion.NO_OP_OC:
        return 0;
      case OnCompletion.OPT_IN_OC:
        return 1;
      case OnCompletion.CLOSE_OUT_OC:
        return 2;
      case OnCompletion.CLEAR_STATE_OC:
        return 3;
      case OnCompletion.UPDATE_APPLICATION_OC:
        return 4;
      case OnCompletion.DELETE_APPLICATION_OC:
        return 5;
    }
  }
}

const kOnCompletionEnumMap = {
  OnCompletion.NO_OP_OC: 'noop',
  OnCompletion.OPT_IN_OC: 'optin',
  OnCompletion.CLOSE_OUT_OC: 'closeout',
  OnCompletion.CLEAR_STATE_OC: 'clear',
  OnCompletion.UPDATE_APPLICATION_OC: 'update',
  OnCompletion.DELETE_APPLICATION_OC: 'delete',
};
