import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/state/cart_controller.dart';

Product _product(int id, String price) => Product(
      id: id,
      name: 'Product $id',
      tagline: 'Tagline',
      description: 'Description',
      price: price,
      currency: 'USD',
      image: 'https://example.com/$id.png',
    );

void main() {
  group('CartController', () {
    late CartController cart;
    late Product phone;
    late Product mac;

    setUp(() {
      cart = CartController();
      phone = _product(1, r'$999');
      mac = _product(6, r'$2,499');
    });

    tearDown(() => cart.dispose());

    test('adds products and combines quantities', () {
      cart.add(phone);
      cart.add(phone);
      cart.add(mac);
      expect(cart.totalCount, 3);
      expect(cart.totalPrice, 4497.0);
      expect(cart.items.length, 2);
      expect(cart.items.first.quantity, 2);
    });

    test('decrement removes item at one', () {
      cart.add(phone);
      cart.decrement(phone.id);
      expect(cart.isEmpty, isTrue);
      expect(cart.totalCount, 0);
    });

    test('remove and clear update state', () {
      cart.add(phone);
      cart.add(mac);
      cart.remove(phone.id);
      expect(cart.items.single.product.id, mac.id);
      cart.clear();
      expect(cart.isEmpty, isTrue);
    });

    test('notifies listeners on changes', () {
      var notifications = 0;
      cart.addListener(() => notifications++);
      cart.add(phone);
      cart.increment(phone.id);
      cart.decrement(phone.id);
      cart.remove(phone.id);
      expect(notifications, 4);
    });
  });
}
