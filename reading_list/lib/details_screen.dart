
import 'package:flutter/material.dart';

import 'models/book.dart';

enum BookAction {
  toggleRead,
  delete,
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.book,
  });

  final Book book;

  Future<void> _deleteBook(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete book?'),
          content: Text("Delete '${book.title}'?"),
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
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!context.mounted) return;

    if (confirmed == true) {
      Navigator.of(context).pop(BookAction.delete);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.menu_book,
                      size: 70,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      book.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Author'),
                      subtitle: Text(book.author),
                    ),
                    ListTile(
                      leading: const Icon(Icons.auto_stories),
                      title: const Text('Pages'),
                      subtitle: Text('${book.pages}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_month),
                      title: const Text('Year'),
                      subtitle: Text(
                        book.year?.toString() ?? 'Year unknown',
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        book.read
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                      ),
                      title: const Text('Status'),
                      subtitle: Text(
                        book.read ? 'Read' : 'Unread',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pop(
                  BookAction.toggleRead,
                );
              },
              icon: const Icon(Icons.check),
              label: Text(
                book.read ? 'Mark as unread' : 'Mark as read',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _deleteBook(context),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
