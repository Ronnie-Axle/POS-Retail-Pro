import 'package:flutter/material.dart';

import 'app_state.dart';
import 'screens/screen_host.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const RetailApp());
}

class RetailApp extends StatefulWidget {
  const RetailApp({super.key});

  @override
  State<RetailApp> createState() => _RetailAppState();
}

class _RetailAppState extends State<RetailApp> {
  final CartBloc cart = CartBloc();
  final InventoryBloc inventory = InventoryBloc();
  final SyncBloc sync = SyncBloc();
  RetailPage page = RetailPage.welcome;
  int themeIndex = 0;

  @override
  void dispose() {
    cart.dispose();
    inventory.dispose();
    sync.dispose();
    super.dispose();
  }

  void navigate(RetailPage next) {
    setState(() => page = next);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS Retail Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(AppTheme.palette[themeIndex]),
      home: RetailScreenHost(
        page: page,
        onNavigate: navigate,
        cart: cart,
        inventory: inventory,
        sync: sync,
        onThemeChanged: (index) => setState(() => themeIndex = index),
      ),
    );
  }
}
