import 'package:flutter_test/flutter_test.dart';
import 'package:stream_control/core/validators/validators.dart';

void main() {
  group('validateHost', () {
    test('returns error when value is null or empty', () {
      expect(validateHost(null), isNotNull);
      expect(validateHost(''), isNotNull);
      expect(validateHost('   '), isNotNull);
    });

    test('accepts valid IPv4 addresses', () {
      expect(validateHost('192.168.1.10'), isNull);
      expect(validateHost('  10.0.0.1  '), isNull);
      expect(validateHost('127.0.0.1'), isNull);
    });

    test('accepts valid IPv6 addresses', () {
      expect(validateHost('::1'), isNull);
      expect(validateHost('2001:db8::1'), isNull);
      expect(validateHost('fe80::1%eth0'), isNull);
      expect(validateHost('[2001:db8::1]'), isNull);
    });

    test('rejects invalid IPv6 addresses', () {
      expect(validateHost('gggg::1'), isNotNull);
      expect(validateHost('2001:db8::1::2'), isNotNull);
    });

    test('accepts valid hostnames', () {
      expect(validateHost('example.com'), isNull);
      expect(validateHost('sub.domain.co'), isNull);
      expect(validateHost('LOCALHOST'), isNull);
      expect(validateHost('my-host'), isNull);
    });

    test('rejects invalid hostnames', () {
      expect(validateHost('exa mple.com'), isNotNull);
      expect(validateHost('domain!.com'), isNotNull);
      expect(validateHost('@@@'), isNotNull);
      expect(validateHost('host name spaces'), isNotNull);
    });

    test('accepts hostname or IP with scheme (http/https)', () {
      expect(validateHost('http://example.com'), isNull);
      expect(validateHost('https://192.168.0.2'), isNull);
      expect(validateHost('HTTP://local.dev'), isNull);
    });

    test('rejects invalid inputs even with scheme', () {
      expect(validateHost('https://bad input'), isNotNull);
      expect(validateHost('http://!!invalid!!'), isNotNull);
    });
  });

  group('validatePort', () {
    test('returns error for null or empty input', () {
      expect(validatePort(null), isNotNull);
      expect(validatePort(''), isNotNull);
      expect(validatePort('   '), isNotNull);
    });

    test('accepts valid ports', () {
      expect(validatePort('1'), isNull);
      expect(validatePort('80'), isNull);
      expect(validatePort('443'), isNull);
      expect(validatePort('65535'), isNull);
    });

    test('rejects non-numeric ports', () {
      expect(validatePort('abc'), isNotNull);
      expect(validatePort('12a'), isNotNull);
      expect(validatePort('port'), isNotNull);
    });

    test('rejects out-of-range ports', () {
      expect(validatePort('0'), isNotNull);
      expect(validatePort('-1'), isNotNull);
      expect(validatePort('70000'), isNotNull);
    });
  });
}
