
import 'package:flutter/material.dart';

import 'main.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    super.key,
    required this.items,
    required this.onRemove,
  });

  final List<Book> items;
  final void Function(Book) onRemove;

  @override
  Widget build(BuildContext context) {
    final total = items.fold<int>(
      0,
          (sum, book) => sum + book.price,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: items.isEmpty
                ? const Center(
              child: Text('Your cart is empty'),
            )
                : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final book = items[index];

                return ListTile(
                  title: Text(book.title),
                  subtitle: Text('${book.price} ₸'),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      onRemove(book);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Total: $total ₸',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),
          ),
        ],
      ),
    );
  }
}
