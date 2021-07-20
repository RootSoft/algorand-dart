enum OnCompletion {
  NO_OP_OC,
  OPT_IN_OC,
  CLOSE_OUT_OC,
  CLEAR_STATE_OC,
  UPDATE_APPLICATION_OC,
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
