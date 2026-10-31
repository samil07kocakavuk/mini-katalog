import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../state/app_scope.dart';
import '../state/cart_controller.dart';
import '../utils/formatters.dart';
import 'product_list_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = AppScope.of(context).cart;
    return AnimatedBuilder(
      animation: cart,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sepetim'),
            actions: [
              if (!cart.isEmpty)
                TextButton(
                  onPressed: cart.clear,
                  child: const Text('Temizle'),
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            top: false,
            child: cart.isEmpty
                ? _EmptyCart(
                    onBrowse: () => Navigator.pushReplacementNamed(
                      context,
                      ProductListScreen.routeName,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return _CartRow(item: item, cart: cart);
                    },
                  ),
          ),
          bottomNavigationBar: _CartSummary(cart: cart),
        );
      },
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.cart});

  final CartController cart;

  @override
  Widget build(BuildContext context) {
    if (cart.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Toplam'),
              const Spacer(),
              Text(
                formatUsd(cart.totalPrice),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Demo uygulaması: ödeme alınmaz.'),
                  ),
                );
              },
              child: const Text('Ödemeye Geç (Demo)'),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 72,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Sepetin boş',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Beğendiğin ürünleri sepete ekleyerek başla.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: onBrowse,
              child: const Text('Ürünlere Göz At'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({required this.item, required this.cart});

  final CartItem item;
  final CartController cart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 72,
              height: 72,
              child: Image.network(
                item.product.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const ColoredBox(
                  color: Color(0xFFF1F3F5),
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatUsd(item.product.priceValue),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onPressed: () => cart.decrement(item.product.id),
                      tooltip: 'Azalt',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${item.quantity}',
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add,
                      onPressed: () => cart.increment(item.product.id),
                      tooltip: 'Artır',
                    ),
                    const Spacer(),
                    Text(
                      formatUsd(item.lineTotal),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      tooltip: 'Ürünü kaldır',
                      onPressed: () => cart.remove(item.product.id),
                      icon: const Icon(Icons.delete_outline, size: 20),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 18),
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFFF3F4F6),
        minimumSize: const Size(32, 32),
        padding: EdgeInsets.zero,
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}
