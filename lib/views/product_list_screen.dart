import 'package:flutter/material.dart';

import '../components/cart_icon_button.dart';
import '../components/error_view.dart';
import '../components/product_card.dart';
import '../models/product.dart';
import '../state/app_scope.dart';
import '../state/catalog_controller.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  static const String routeName = '/products';

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalog = AppScope.of(context).catalog;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürünler'),
        actions: const [CartIconButton(), SizedBox(width: 8)],
      ),
      body: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation: catalog,
          builder: (context, _) {
            final products = _filter(catalog.products);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: 'Ürün ara',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Aramayı temizle',
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                              icon: const Icon(Icons.close),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${products.length} ürün',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _buildBody(context, catalog, products),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CatalogController catalog,
    List<Product> products,
  ) {
    if (catalog.isLoading && !catalog.hasProducts) {
      return const Center(child: CircularProgressIndicator());
    }
    if (catalog.error != null && !catalog.hasProducts) {
      return ErrorView(message: catalog.error!, onRetry: catalog.load);
    }
    if (products.isEmpty) {
      return RefreshIndicator(
        onRefresh: catalog.load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.5,
              child: Center(
                child: Text(
                  _query.isEmpty
                      ? 'Henüz ürün yok.'
                      : 'Aramanla eşleşen ürün bulunamadı.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        await catalog.load();
        if (!context.mounted) return;
        final error = catalog.error;
        if (error != null && catalog.hasProducts) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        }
      },
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 276,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            onTap: () => Navigator.pushNamed(
              context,
              ProductDetailScreen.routeName,
              arguments: product,
            ),
          );
        },
      ),
    );
  }

  List<Product> _filter(List<Product> products) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return products;
    return products.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.tagline.toLowerCase().contains(query);
    }).toList(growable: false);
  }
}
