import 'package:flutter_test/flutter_test.dart';
import 'package:stream_control/core/utils/device_type.dart';

void main() {
  group('validateDeviceType', () {
    test('returns the Device Type', () {
      expect(fromSize(400), DeviceType.phone);
      expect(fromSize(700), DeviceType.tablet);
    });
  });
}
