//Not strict validator, just checking the string format - IPv4/IPv6/hostname
//Rejects only clearly invalid inputs
//The http request is the ultimate validator

String? validateHost(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter a host or IP address';
  }

  String input = value.trim();

  // Strip optional scheme (http:// or https://)
  final schemeRegex = RegExp(r'^(https?:\/\/)', caseSensitive: false);
  input = input.replaceFirst(schemeRegex, '');

  // IPv6 allow at most one "::"
  final doubleColonCount = RegExp(r'::').allMatches(input).length;
  if (doubleColonCount > 1) {
    return 'Invalid IPv6 address';
  }

  // IPv6
  final ipv6Regex = RegExp(
    r'^(\[)?([0-9A-Fa-f:]+(%[0-9A-Za-z._-]+)?)\]?$',
  );

  // IPv4 (not strictly 0–255)
  final ipv4Regex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');

  // hostname
  final hostRegex = RegExp(
      r'^[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?(?:\.[A-Za-z0-9-]+)*$');

  if (ipv4Regex.hasMatch(input)) return null;
  if (ipv6Regex.hasMatch(input)) return null;
  if (hostRegex.hasMatch(input)) return null;

  return 'Invalid host or IP address';
}

String? validatePort(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a port';
  }

  final port = int.tryParse(value);
  if (port == null || port < 1 || port > 65535) {
    return 'Invalid port number';
  }

  return null;
}
