import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/product.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({this.endpoint = _defaultEndpoint});

  static const String _defaultEndpoint = 'https://wantapi.com/products.php';
  static const Duration _timeout = Duration(seconds: 20);

  final String endpoint;

  Future<List<Product>> fetchProducts() async {
    final client = HttpClient()..connectionTimeout = _timeout;

    try {
      final request =
          await client.getUrl(Uri.parse(endpoint)).timeout(_timeout);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final response = await request.close().timeout(_timeout);
      final body =
          await response.transform(utf8.decoder).join().timeout(_timeout);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException('Sunucu hatası (${response.statusCode}).');
      }

      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        throw const ApiException('Beklenmeyen veri biçimi.');
      }

      final data = decoded['data'];
      if (data is! List<dynamic>) {
        throw const ApiException('Ürün listesi bulunamadı.');
      }

      return data
          .whereType<Map<dynamic, dynamic>>()
          .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false);
    } on ApiException {
      rethrow;
    } on SocketException {
      throw const ApiException('İnternet bağlantısı kurulamadı.');
    } on TimeoutException {
      throw const ApiException('İstek zaman aşımına uğradı.');
    } on FormatException {
      throw const ApiException('Sunucu verisi çözümlenemedi.');
    } catch (_) {
      throw const ApiException('Ürün verisi işlenemedi.');
    } finally {
      client.close(force: true);
    }
  }
}
