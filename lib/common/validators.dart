String? validateHost(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter a host or IP address';
  }

  final input = value.trim();

  final schemePattern = RegExp(r'^(https?:\/\/)?', caseSensitive: false);

  // Strip scheme if present for further validation
  final withoutScheme = input.replaceFirst(schemePattern, '');

  // Patterns for hostnames and IPv4
  final ipPattern = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
  final hostnamePattern = RegExp(r'^[a-zA-Z0-9.-]+$');

  if (!ipPattern.hasMatch(withoutScheme) &&
      !hostnamePattern.hasMatch(withoutScheme)) {
    return 'Invalid hostname or IP address';
  }

  return null;
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
