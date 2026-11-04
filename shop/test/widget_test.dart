import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:shop/main.dart';
import 'package:shop/models/cart.dart';

void main() {
  testWidgets('Book Shop opens', (WidgetTester tester) async {
    // Set a realistic phone screen size
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 3.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Provide Cart to the entire application
    await tester.pumpWidget(
      ChangeNotifierProvider<Cart>(create: (_) => Cart(), child: const Shell()),
    );

    // Check that the main screen opens
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Book Shop'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
  });
}
