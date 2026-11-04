import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_badge.dart';
import 'models/book.dart';
import 'models/cart.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    debugPrint('BooksScreen build');

    final filteredBooks = books.where((book) {
      final query = _searchQuery.toLowerCase().trim();

      return book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search books...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : const Text('Book Shop'),
        actions: [
          IconButton(
            tooltip: _isSearching ? 'Close search' : 'Search',
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                _searchQuery = '';
              });
            },
          ),
          const CartBadge(),
        ],
      ),
      body: filteredBooks.isEmpty
          ? const Center(child: Text('No books found'))
          : ListView.builder(
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                return BookRow(
                  key: ValueKey(filteredBooks[index].title),
                  book: filteredBooks[index],
                );
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
    final quantity = context.select<Cart, int>((cart) => cart.qtyOf(book));

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
            final wasNew = context.read<Cart>().add(book);

            if (wasNew) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: const Text('Add'),
        ),
      ),
    );
  }
}
