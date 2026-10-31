import 'package:flutter/widgets.dart';

import 'cart_controller.dart';
import 'catalog_controller.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.catalog,
    required this.cart,
    required super.child,
  });

  final CatalogController catalog;
  final CartController cart;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope bulunamadı.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      catalog != oldWidget.catalog || cart != oldWidget.cart;
}
