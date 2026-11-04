import 'package:flutter/foundation.dart';

import 'book.dart';

class Cart extends ChangeNotifier {
  final List<Book> _items = [];

  List<Book> get items => List.unmodifiable(_items);

  int get count => _items.length;

  int get total => _items.fold<int>(0, (sum, book) => sum + book.price);

  bool add(Book book) {
    if (_items.contains(book)) return false;

    _items.add(book);
    notifyListeners();
    return true;
  }

  void remove(Book book) {
    if (_items.remove(book)) {
      notifyListeners();
    }
  }

  void clear() {
    if (_items.isEmpty) return;

    _items.clear();
    notifyListeners();
  }
}
