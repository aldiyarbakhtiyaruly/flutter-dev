import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final int count = context.select<Cart, int>((cart) => cart.count);

    debugPrint('badge build: $count');

    return IconButton(
      tooltip: 'Cart: $count unique books',
      onPressed: () {
        Navigator.of(context).pushNamed('/cart');
      },
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.shopping_cart_outlined),
      ),
    );
  }
}
