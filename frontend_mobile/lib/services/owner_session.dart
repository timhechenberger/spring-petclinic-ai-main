import 'package:flutter/foundation.dart';

class OwnerSession {
  static final ValueNotifier<int> currentOwnerId = ValueNotifier<int>(1);

  static void setOwnerId(int ownerId) {
    if (ownerId <= 0) return;
    currentOwnerId.value = ownerId;
  }

  static int get ownerId => currentOwnerId.value;
}