import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retail/app_state.dart';
import 'package:retail/main.dart';

void main() {
  testWidgets('welcome screen opens the login screen', (tester) async {
    await tester.pumpWidget(const RetailApp());

    expect(find.text('POS Retail Pro'), findsOneWidget);
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Sign in to your account'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
  });

  testWidgets('dashboard quick action opens the product catalog', (
    tester,
  ) async {
    await tester.pumpWidget(const RetailApp());
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New Sale'));
    await tester.pumpAndSettle();

    expect(find.text('Search products...'), findsOneWidget);
    expect(find.text('Coca Cola 500ml'), findsOneWidget);
  });

  test('cart totals include the configured 18% VAT', () {
    final cart = CartBloc();
    expect(cart.subtotal, 7000);
    expect(cart.tax, 1260);
    expect(cart.total, 8260);

    cart.dispose();
  });

  test('offline sale receives a UUID v4 idempotency key', () {
    final sync = SyncBloc()..setOnline(false);
    final id = sync.queueSale(8260);

    expect(sync.isOnline, isFalse);
    expect(sync.pendingCount, 1);
    expect(sync.pendingSales.single.total, 8260);
    expect(
      RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      ).hasMatch(id),
      isTrue,
    );

    sync.dispose();
  });
}
