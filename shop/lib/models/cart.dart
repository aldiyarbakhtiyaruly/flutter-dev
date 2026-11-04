import 'package:flutter/foundation.dart';

import 'book.dart';

class Cart extends ChangeNotifier {
  final Map<Book, int> _qty = {};

  // All distinct books in the cart
  List<Book> get items {
    return List.unmodifiable(_qty.keys);
  }

  // Number of distinct books
  int get count => _qty.length;

  // Quantity of a specific book
  int qtyOf(Book book) {
    return _qty[book] ?? 0;
  }

  // Total number of copies
  int get totalQuantity {
    return _qty.values.fold<int>(0, (sum, quantity) => sum + quantity);
  }

  // Total cart price
  int get total {
    int sum = 0;

    _qty.forEach((book, quantity) {
      sum += book.price * quantity;
    });

    return sum;
  }

  // Add a book or increase its quantity
  bool add(Book book) {
    final bool isNew = !_qty.containsKey(book);

    _qty[book] = (_qty[book] ?? 0) + 1;

    notifyListeners();

    return isNew;
  }

  // Decrease quantity by one
  void decrement(Book book) {
    final int? current = _qty[book];

    if (current == null) {
      return;
    }

    if (current <= 1) {
      _qty.remove(book);
    } else {
      _qty[book] = current - 1;
    }

    notifyListeners();
  }

  // Remove all copies of a book
  void remove(Book book) {
    if (_qty.remove(book) != null) {
      notifyListeners();
    }
  }

  // Remove everything from the cart
  void clear() {
    if (_qty.isEmpty) {
      return;
    }

    _qty.clear();

    notifyListeners();
  }
}
