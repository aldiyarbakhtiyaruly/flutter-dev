import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              builder: (context, cart, child) {
                if (cart.items.isEmpty) {
                  return const Center(child: Text('Your cart is empty'));
                }

                return ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final book = cart.items[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.menu_book),
                        title: Text(book.title),
                        subtitle: Text('${book.price} ₸'),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            context.read<Cart>().remove(book);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Total: ${cart.total} ₸',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
