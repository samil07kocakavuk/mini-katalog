import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/models/product.dart';

void main() {
  group('Product', () {
    final json = <String, dynamic>{
      'id': 6,
      'name': 'MacBook Pro 16"',
      'tagline': 'Mind-blowing.',
      'description': 'A powerful laptop.',
      'price': r'$2,499',
      'currency': 'USD',
      'image': 'https://example.com/macbook.png',
      'specs': <String, dynamic>{'chip': 'M3 Max', 'display': '16"'},
    };

    test('fromJson parses fields and specs', () {
      final product = Product.fromJson(json);
      expect(product.id, 6);
      expect(product.name, 'MacBook Pro 16"');
      expect(product.priceValue, 2499);
      expect(product.specs, {'chip': 'M3 Max', 'display': '16"'});
    });

    test('priceValue ignores currency formatting', () {
      expect(Product.fromJson({...json, 'price': r'$999'}).priceValue, 999);
    });

    test('toJson keeps the model data', () {
      final product = Product.fromJson(json);
      final encoded = product.toJson();
      expect(encoded['name'], json['name']);
      expect(encoded['price'], json['price']);
      expect(encoded['specs'], json['specs']);
    });

    test('missing fields fall back safely', () {
      final product = Product.fromJson(<String, dynamic>{});
      expect(product.id, 0);
      expect(product.name, '');
      expect(product.priceValue, 0);
      expect(product.specs, isEmpty);
    });
  });
}
