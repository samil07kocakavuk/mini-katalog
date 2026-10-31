import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'http_types.dart';
import 'network_exception.dart';

Future<FetchResponse> fetchResponse(String url) async {
  final client = HttpClient()
    ..connectionTimeout = const Duration(seconds: 20);
  try {
    final request = await client
        .getUrl(Uri.parse(url))
        .timeout(const Duration(seconds: 20));
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');
    final response = await request.close().timeout(
          const Duration(seconds: 20),
        );
    final body = await response
        .transform(utf8.decoder)
        .join()
        .timeout(const Duration(seconds: 20));
    return FetchResponse(response.statusCode, body);
  } on SocketException {
    throw const FetchException('İnternet bağlantısı kurulamadı.');
  } on TimeoutException {
    throw const FetchException('İstek zaman aşımına uğradı.');
  } catch (_) {
    throw const FetchException('İnternet bağlantısı kurulamadı.');
  } finally {
    client.close(force: true);
  }
}
