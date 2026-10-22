
import 'package:flutter/material.dart';

import 'models/book.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _author = TextEditingController();
  final _pages = TextEditingController();
  final _year = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _pages.dispose();
    _year.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final book = Book(
        title: _title.text.trim(),
        author: _author.text.trim(),
        pages: int.parse(_pages.text.trim()),
        year: int.tryParse(_year.text.trim()),
      );

      Navigator.of(context).pop(book);
    }
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    );
  }

  void _unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add book'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'New book',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),

              // TITLE
              TextFormField(
                controller: _title,
                decoration: _decoration('Title'),
                textInputAction: TextInputAction.next,
                onTapOutside: (_) => _unfocus(),
                validator: (v) {
                  if ((v ?? '').trim().length < 2) {
                    return 'At least 2 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // AUTHOR
              TextFormField(
                controller: _author,
                decoration: _decoration('Author'),
                textInputAction: TextInputAction.next,
                onTapOutside: (_) => _unfocus(),
                validator: (v) {
                  if ((v ?? '').trim().isEmpty) {
                    return 'Author is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // PAGES
              TextFormField(
                controller: _pages,
                decoration: _decoration('Pages'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onTapOutside: (_) => _unfocus(),
                validator: (v) {
                  final n = int.tryParse((v ?? '').trim());

                  if (n == null || n <= 0) {
                    return 'A whole number above 0';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // YEAR
              TextFormField(
                controller: _year,
                decoration: _decoration('Year (optional)'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onTapOutside: (_) => _unfocus(),
                onFieldSubmitted: (_) => _save(),
                validator: (v) {
                  final text = (v ?? '').trim();

                  if (text.isEmpty) return null;

                  final year = int.tryParse(text);

                  if (year == null ||
                      year < 1450 ||
                      year > DateTime.now().year) {
                    return 'Enter a valid year';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
