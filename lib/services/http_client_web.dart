// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:async';
import 'dart:html' as html;

import 'http_types.dart';
import 'network_exception.dart';

Future<FetchResponse> fetchResponse(String url) async {
  try {
    final request = await html.HttpRequest.request(
      url,
      method: 'GET',
      requestHeaders: const {'Accept': 'application/json'},
      responseType: 'text',
    ).timeout(const Duration(seconds: 20));
    return FetchResponse(request.status ?? 0, request.responseText ?? '');
  } on TimeoutException {
    throw const FetchException('İstek zaman aşımına uğradı.');
  } catch (_) {
    throw const FetchException('İnternet bağlantısı kurulamadı.');
  }
}
