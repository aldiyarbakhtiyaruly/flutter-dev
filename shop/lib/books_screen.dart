import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_badge.dart';
import 'models/book.dart';
import 'models/cart.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('BooksScreen build');

    final cart = context.watch<Cart>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Shop'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text('${cart.total} ₸'),
            ),
          ),
          const CartBadge(),
        ],
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          final added = cart.items.contains(book);

          debugPrint('row ${book.title}');

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.menu_book)),
              title: Text(book.title),
              subtitle: Text('${book.author}\n${book.price} ₸'),
              isThreeLine: true,
              trailing: added
                  ? const Text(
                      'Added',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : OutlinedButton(
                      onPressed: () {
                        context.read<Cart>().add(book);
                      },
                      child: const Text('Add'),
                    ),
            ),
          );
        },
      ),
    );
  }
}
