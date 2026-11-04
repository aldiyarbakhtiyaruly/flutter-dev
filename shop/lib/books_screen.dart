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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Shop'),
        actions: const [CartBadge()],
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final Book book = books[index];

          return BookRow(book: book);
        },
      ),
    );
  }
}

class BookRow extends StatelessWidget {
  const BookRow({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final int quantity = context.select<Cart, int>((cart) => cart.qtyOf(book));

    debugPrint('row ${book.title}: $quantity');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.menu_book)),
        title: Text(book.title),
        subtitle: Text(
          '${book.author}\n'
          '${book.price} ₸\n'
          'In cart: $quantity',
        ),
        isThreeLine: true,
        trailing: OutlinedButton(
          onPressed: () {
            context.read<Cart>().add(book);
          },
          child: const Text('Add'),
        ),
      ),
    );
  }
}
