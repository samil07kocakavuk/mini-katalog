import 'dart:async';
import 'dart:convert';

import '../models/product.dart';
import 'http_client.dart';
import 'network_exception.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({this.endpoint = _defaultEndpoint});

  static const String _defaultEndpoint = 'https://wantapi.com/products.php';

  final String endpoint;

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await fetchResponse(endpoint).timeout(
        const Duration(seconds: 25),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException('Sunucu hatası (${response.statusCode}).');
      }

      final decoded = jsonDecode(response.body);
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
    } on FetchException catch (error) {
      throw ApiException(error.message);
    } on TimeoutException {
      throw const ApiException('İstek zaman aşımına uğradı.');
    } on FormatException {
      throw const ApiException('Sunucu verisi çözümlenemedi.');
    } catch (_) {
      throw const ApiException('Ürün verisi işlenemedi.');
    }
  }
}
