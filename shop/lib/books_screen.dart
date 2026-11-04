
import 'package:flutter/material.dart';

import 'main.dart';
import 'cart_badge.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({
    super.key,
    required this.cart,
    required this.total,
    required this.onAdd,
  });

  final List<Book> cart;
  final int total;
  final void Function(Book) onAdd;

  @override
  Widget build(BuildContext context) {
    debugPrint('BooksScreen build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Shop'),
        actions: [
          Center(
            child: Text('$total ₸'),
          ),
          CartBadge(
            count: cart.length,
            total: total,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          final added = cart.contains(book);

          debugPrint('row ${book.title}');

          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.menu_book),
            ),
            title: Text(book.title),
            subtitle: Text(
              '${book.author}\n${book.price} ₸',
            ),
            isThreeLine: true,
            trailing: added
                ? const Text('Added')
                : OutlinedButton(
              onPressed: () => onAdd(book),
              child: const Text('Add'),
            ),
          );
        },
      ),
    );
  }
}
