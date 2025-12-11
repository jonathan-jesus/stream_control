import 'package:flutter/material.dart';

enum VmixErrorType {
  timeout,
  unauthorized,
  invalidXml,
  network,
  disconnected,
  unknown,
}

extension VmixErrors on VmixErrorType {
  String get message {
    switch (this) {
      case VmixErrorType.timeout:
        return 'Connection timeout';
      case VmixErrorType.unauthorized:
        return 'Unauthorized access';
      case VmixErrorType.invalidXml:
        return 'Invalid XML response';
      case VmixErrorType.network:
        return "Check your connection or make sure vMix is running";
      case VmixErrorType.disconnected:
        return 'Disconnected';
      case VmixErrorType.unknown:
        return 'Unexpected error';
    }
  }

  IconData get icon {
    switch (this) {
      case VmixErrorType.timeout:
        return Icons.timer_off_outlined;
      case VmixErrorType.unauthorized:
        return Icons.lock_outline_rounded;
      case VmixErrorType.invalidXml:
        return Icons.dangerous_outlined;
      case VmixErrorType.network:
        return Icons.signal_wifi_bad_sharp;
      case VmixErrorType.disconnected:
        return Icons.signal_wifi_off_rounded;
      case VmixErrorType.unknown:
        return Icons.dangerous_outlined;
    }
  }
}
