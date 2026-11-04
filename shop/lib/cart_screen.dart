import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/book.dart';
import 'models/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('CartScreen build');

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: Column(
        children: [
          Expanded(
            child: Consumer<Cart>(
              child: const Center(child: Text('Your cart is empty')),
              builder: (context, cart, emptyChild) {
                final items = cart.items;

                if (items.isEmpty) {
                  return emptyChild!;
                }

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final Book book = items[index];

                    return CartBookRow(key: ValueKey(book.title), book: book);
                  },
                );
              },
            ),
          ),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Unique books: ${cart.count}'),
                    Text('Total copies: ${cart.totalQuantity}'),
                    const SizedBox(height: 8),
                    Text(
                      'Total: ${cart.total} ₸',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CartBookRow extends StatelessWidget {
  const CartBookRow({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final int quantity = context.select<Cart, int>((cart) => cart.qtyOf(book));

    debugPrint('cart row ${book.title}: $quantity');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ListTile(
        title: Text(book.title),
        subtitle: Text(
          '${book.price} ₸ × $quantity = '
          '${book.price * quantity} ₸',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Decrease',
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                context.read<Cart>().decrement(book);
              },
            ),
            Text('$quantity'),
            IconButton(
              tooltip: 'Increase',
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                context.read<Cart>().add(book);
              },
            ),
            IconButton(
              tooltip: 'Remove',
              icon: const Icon(Icons.close),
              onPressed: () {
                context.read<Cart>().remove(book);
              },
            ),
          ],
        ),
      ),
    );
  }
}
