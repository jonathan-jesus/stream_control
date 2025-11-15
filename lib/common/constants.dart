import 'package:flutter/material.dart';

enum DeviceType { phone, tablet }

DeviceType getDeviceType(BuildContext context) {
  return MediaQuery.sizeOf(context).shortestSide < 550
      ? DeviceType.phone
      : DeviceType.tablet;
}

extension StringCasingExtension on String {
  String capitalizeFirst() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
