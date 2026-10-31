import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/services/api_service.dart';

void main() {
  group('ApiService', () {
    late HttpServer server;

    setUp(() async {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    });

    tearDown(() async {
      await server.close(force: true);
    });

    test('parses product list from JSON', () async {
      server.listen((request) async {
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode(<String, dynamic>{
            'data': <Map<String, dynamic>>[
              <String, dynamic>{
                'id': 1,
                'name': 'iPhone 15 Pro',
                'tagline': 'Titanium.',
                'description': 'A phone.',
                'price': r'$999',
                'currency': 'USD',
                'image': 'https://example.com/phone.png',
                'specs': <String, String>{'storage': '256 GB'},
              },
            ],
          }),
        );
        await request.response.close();
      });

      final api = ApiService(
        endpoint: 'http://127.0.0.1:${server.port}/products.php',
      );
      final products = await api.fetchProducts();

      expect(products, hasLength(1));
      expect(products.single.name, 'iPhone 15 Pro');
      expect(products.single.priceValue, 999);
      expect(products.single.specs['storage'], '256 GB');
    });

    test('throws ApiException for a server error', () async {
      server.listen((request) async {
        request.response.statusCode = HttpStatus.internalServerError;
        await request.response.close();
      });

      final api = ApiService(
        endpoint: 'http://127.0.0.1:${server.port}/products.php',
      );

      await expectLater(api.fetchProducts(), throwsA(isA<ApiException>()));
    });
  });
}
