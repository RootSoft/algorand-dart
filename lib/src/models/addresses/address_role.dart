enum AddressRole {
  SENDER,
  RECEIVER,
  FREEZE_TARGET,
}

extension AddressRoleExtension on AddressRole {
  String get value {
    switch (this) {
      case AddressRole.SENDER:
        return 'sender';
      case AddressRole.RECEIVER:
        return 'receiver';
      case AddressRole.FREEZE_TARGET:
        return 'freeze-target';
    }
  }
}
