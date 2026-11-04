import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/book.dart';
import 'models/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _showDetails = true;

  Future<void> _confirmClearCart() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear cart?'),
          content: const Text('Are you sure you want to remove all books?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (shouldClear == true) {
      context.read<Cart>().clear();

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Cart cleared')));
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('CartScreen build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          Consumer<Cart>(
            builder: (context, cart, child) {
              return IconButton(
                tooltip: 'Clear cart',
                icon: const Icon(Icons.delete_outline),
                onPressed: cart.count == 0 ? null : _confirmClearCart,
              );
            },
          ),
        ],
      ),
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
                    final book = items[index];

                    return CartBookRow(key: ValueKey(book.title), book: book);
                  },
                );
              },
            ),
          ),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Card(
                margin: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Order Summary',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Icon(
                        _showDetails ? Icons.expand_less : Icons.expand_more,
                      ),
                      onTap: () {
                        setState(() {
                          _showDetails = !_showDetails;
                        });
                      },
                    ),
                    if (_showDetails) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Text('Unique books: ${cart.count}'),
                            Text('Total copies: ${cart.totalQuantity}'),
                            const SizedBox(height: 8),
                            Text(
                              'Total: ${cart.total} ₸',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
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
    final quantity = context.select<Cart, int>((cart) => cart.qtyOf(book));

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
