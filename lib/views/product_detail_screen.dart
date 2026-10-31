import 'package:flutter/material.dart';

import '../components/cart_icon_button.dart';
import '../models/product.dart';
import '../state/app_scope.dart';
import '../utils/formatters.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  static const String routeName = '/product';

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = AppScope.of(context).cart;
    final specs = product.specs.entries.toList(growable: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Detayı'),
        actions: const [CartIconButton(), SizedBox(width: 8)],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 1.15,
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      semanticLabel: product.name,
                      errorBuilder: (context, error, stackTrace) =>
                          const ColoredBox(
                        color: Color(0xFFF1F3F5),
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 56,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.tagline,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      formatUsd(product.priceValue),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Açıklama',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (specs.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Özellikler',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final entry in specs)
                            _SpecChip(
                              label: _labelFor(entry.key),
                              value: entry.value,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () {
              cart.add(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${product.name} sepete eklendi.')),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Sepete Ekle'),
          ),
        ),
      ),
    );
  }

  String _labelFor(String key) {
    if (key.isEmpty) return key;
    return key[0].toUpperCase() + key.substring(1);
  }
}

class _SpecChip extends StatelessWidget {
  const _SpecChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
