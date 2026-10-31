import 'package:flutter/material.dart';

import 'models/product.dart';
import 'services/api_service.dart';
import 'state/app_scope.dart';
import 'state/cart_controller.dart';
import 'state/catalog_controller.dart';
import 'theme/app_theme.dart';
import 'views/cart_screen.dart';
import 'views/home_screen.dart';
import 'views/product_detail_screen.dart';
import 'views/product_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MiniKatalogApp());
}

class MiniKatalogApp extends StatefulWidget {
  const MiniKatalogApp({super.key});

  @override
  State<MiniKatalogApp> createState() => _MiniKatalogAppState();
}

class _MiniKatalogAppState extends State<MiniKatalogApp> {
  late final CatalogController _catalog;
  late final CartController _cart;

  @override
  void initState() {
    super.initState();
    _catalog = CatalogController(ApiService());
    _cart = CartController();
    _catalog.load();
  }

  @override
  void dispose() {
    _catalog.dispose();
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      catalog: _catalog,
      cart: _cart,
      child: MaterialApp(
        title: 'Mini Katalog',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: HomeScreen.routeName,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.routeName:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
      case ProductListScreen.routeName:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const ProductListScreen(),
        );
      case ProductDetailScreen.routeName:
        final product = settings.arguments;
        if (product is! Product) {
          return _invalidRoute(settings);
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ProductDetailScreen(product: product),
        );
      case CartScreen.routeName:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const CartScreen(),
        );
      default:
        return _invalidRoute(settings);
    }
  }

  Route<dynamic> _invalidRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Sayfa bulunamadı')),
        body: const Center(child: Text('Geçersiz sayfa isteği.')),
      ),
    );
  }
}
