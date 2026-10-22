
import 'package:flutter/material.dart';

import 'models/book.dart';
import 'widgets/book_tile.dart';
import 'details_screen.dart';
import 'add_book_screen.dart';

enum Filter {
  all,
  unread,
  read,
}

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Book> _books = [
    for (final book in seed)
      Book(
        title: book.title,
        author: book.author,
        pages: book.pages,
        year: book.year,
        read: book.read,
      ),
  ];

  Filter _filter = Filter.all;

  List<Book> get _visible => switch (_filter) {
    Filter.all => _books,
    Filter.unread => unread(_books),
    Filter.read => _books.where((b) => b.read).toList(),
  };

  void _toggleBook(Book book) {
    setState(() {
      book.read = !book.read;
    });
  }

  Future<void> _openBook(Book book) async {
    final action = await Navigator.of(context).push<BookAction>(
      MaterialPageRoute(
        builder: (context) => DetailScreen(book: book),
      ),
    );

    if (!mounted) return;

    switch (action) {
      case BookAction.toggleRead:
        setState(() {
          book.read = !book.read;
        });

      case BookAction.delete:
        setState(() {
          _books.remove(book);
        });

      case null:
        break;
    }
  }

  Future<void> _addBook() async {
    final book = await Navigator.of(context).push<Book>(
      MaterialPageRoute(
        builder: (context) => const AddBookScreen(),
      ),
    );

    if (!mounted) return;
    if (book == null) return;

    setState(() {
      _books.add(book);
    });
  }

  Widget _statItem(
      BuildContext context,
      String label,
      String value,
      ) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: textTheme.headlineSmall,
          ),
          Text(
            label,
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        child: Row(
          children: [
            _statItem(
              context,
              'Books',
              '${_books.length}',
            ),
            _statItem(
              context,
              'Pages',
              '${totalPages(_books)}',
            ),
            _statItem(
              context,
              'Unread',
              '${unread(_books).length}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          for (final filter in Filter.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  switch (filter) {
                    Filter.all => 'All',
                    Filter.unread => 'Unread',
                    Filter.read => 'Read',
                  },
                ),
                selected: _filter == filter,
                onSelected: (_) {
                  setState(() {
                    _filter = filter;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleBooks = _visible;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reading list (${visibleBooks.length})',
        ),
      ),
      body: Column(
        children: [
          _buildHeader(context),
          _buildFilters(),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: visibleBooks.length,
              itemBuilder: (context, index) {
                final book = visibleBooks[index];

                return BookTile(
                  book: book,
                  onToggle: () => _toggleBook(book),
                  onTap: () => _openBook(book),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        tooltip: 'Add book',
        child: const Icon(Icons.add),
      ),
    );
  }
}
