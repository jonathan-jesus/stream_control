import 'package:flutter/material.dart';

enum DeviceType { phone, tablet }

DeviceType fromSize(double shortestSide) =>
    shortestSide < 550 ? DeviceType.phone : DeviceType.tablet;

DeviceType getDeviceType(BuildContext context) =>
    fromSize(MediaQuery.sizeOf(context).shortestSide);
