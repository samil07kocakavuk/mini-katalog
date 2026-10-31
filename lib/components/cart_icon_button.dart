import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../views/cart_screen.dart';

class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = AppScope.of(context).cart;
    return AnimatedBuilder(
      animation: cart,
      builder: (context, _) {
        final count = cart.totalCount;
        return IconButton(
          tooltip: 'Sepetim',
          onPressed: () => Navigator.pushNamed(context, CartScreen.routeName),
          icon: Badge(
            isLabelVisible: count > 0,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            label: Text(count > 99 ? '99+' : '$count'),
            child: const Icon(Icons.shopping_bag_outlined),
          ),
        );
      },
    );
  }
}
