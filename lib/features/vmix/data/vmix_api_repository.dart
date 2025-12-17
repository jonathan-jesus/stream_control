import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:stream_control/features/vmix/models/vmix_error_type.dart';

class VmixApiRepository {
  Future<String> fetchState(String uri,
      {String? user, String? password}) async {
    try {
      final parsedUri = Uri.parse(uri);
      Map<String, String>? headers;
      if (user != null && password != null) {
        final credentials = '$user:$password';
        final encoded = base64.encode(utf8.encode(credentials));
        headers = {"Authorization": "Basic $encoded"};
      }
      final response = await http
          .get(parsedUri, headers: headers)
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 401) {
        throw VmixErrorType.unauthorized;
      } else if (response.statusCode == 500) {
        throw VmixErrorType.unknown;
      } else {
        throw VmixErrorType.network;
      }
    } on TimeoutException {
      throw VmixErrorType.timeout;
    } on SocketException {
      throw VmixErrorType.network;
    } on VmixErrorType {
      rethrow;
    }
  }

  Future<http.Response> sendCommand(String uri,
      {required String function,
      String? input,
      String? value,
      String? user,
      String? password}) async {
    try {
      String query = '?Function=$function';
      query = input != null ? '$query&Input=$input' : query;
      query = value != null ? '$query&value=$value' : query;
      final url = Uri.parse('$uri$query');
      Map<String, String>? headers;
      if (user != null && password != null) {
        final credentials = '$user:$password';
        final encoded = base64.encode(utf8.encode(credentials));
        headers = {"Authorization": "Basic $encoded"};
      }
      return await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 5));
    } on TimeoutException {
      throw VmixErrorType.timeout;
    } on VmixErrorType {
      rethrow;
    }
  }
}
