import 'package:flutter/material.dart';

import '../components/cart_icon_button.dart';
import '../components/error_view.dart';
import '../components/product_card.dart';
import '../models/product.dart';
import '../state/app_scope.dart';
import '../state/catalog_controller.dart';
import 'product_detail_screen.dart';
import 'product_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    final catalog = AppScope.of(context).catalog;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Katalog'),
        actions: const [CartIconButton(), SizedBox(width: 8)],
      ),
      body: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation: catalog,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 2118 / 474,
                    child: Image.asset(
                      'assets/images/banner.png',
                      fit: BoxFit.cover,
                      semanticLabel: 'Gift Store banner',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _FeaturedSection(catalog: catalog),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    ProductListScreen.routeName,
                  ),
                  child: const Text('Tüm Ürünleri Gör'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  const _FeaturedSection({required this.catalog});

  final CatalogController catalog;

  @override
  Widget build(BuildContext context) {
    if (catalog.isLoading && !catalog.hasProducts) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (catalog.error != null && !catalog.hasProducts) {
      return SizedBox(
        height: 220,
        child: ErrorView(
          message: catalog.error!,
          onRetry: catalog.load,
        ),
      );
    }
    final featured = catalog.products.take(5).toList(growable: false);
    if (featured.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text('Öne çıkan ürün bulunamadı.')),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Öne Çıkanlar',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(
                context,
                ProductListScreen.routeName,
              ),
              child: const Text('Tümü'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: featured.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = featured[index];
              return SizedBox(
                width: 168,
                child: ProductCard(
                  product: product,
                  onTap: () => _openProduct(context, product),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openProduct(BuildContext context, Product product) {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );
  }
}
