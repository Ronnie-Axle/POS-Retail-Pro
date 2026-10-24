import 'package:flutter/material.dart';

import '../app_state.dart';
import 'welcome_screen.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';
import 'catalog_screen.dart';
import 'checkout_screen.dart';
import 'payment_screen.dart';
import 'inventory_screen.dart';
import 'customers_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'offline_screen.dart';
import 'business_profile_screen.dart';

class RetailScreenHost extends StatelessWidget {
  const RetailScreenHost({
    required this.page,
    required this.onNavigate,
    required this.cart,
    required this.inventory,
    required this.sync,
    required this.onThemeChanged,
    super.key,
  });

  final RetailPage page;
  final ValueChanged<RetailPage> onNavigate;
  final CartBloc cart;
  final InventoryBloc inventory;
  final SyncBloc sync;
  final ValueChanged<int> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return switch (page) {
      RetailPage.welcome => WelcomeScreen(
        onContinue: () {
          sync.setOnline(true);
          onNavigate(RetailPage.login);
        },
      ),
      RetailPage.login => LoginScreen(
        onBack: () => onNavigate(RetailPage.welcome),
        onLogin: () => onNavigate(RetailPage.dashboard),
      ),
      RetailPage.dashboard => DashboardScreen(
        onNavigate: onNavigate,
        sync: sync,
      ),
      RetailPage.catalog => CatalogScreen(
        cart: cart,
        onBack: () => onNavigate(RetailPage.dashboard),
        onCheckout: () => onNavigate(RetailPage.checkout),
      ),
      RetailPage.checkout => CheckoutScreen(
        cart: cart,
        onBack: () => onNavigate(RetailPage.catalog),
        onPay: () => onNavigate(RetailPage.payment),
      ),
      RetailPage.payment => PaymentScreen(
        cart: cart,
        sync: sync,
        onBack: () => onNavigate(RetailPage.checkout),
        onComplete: () => onNavigate(RetailPage.dashboard),
      ),
      RetailPage.inventory => InventoryScreen(
        inventory: inventory,
        onBack: () => onNavigate(RetailPage.dashboard),
      ),
      RetailPage.customers => CustomersScreen(
        onBack: () => onNavigate(RetailPage.dashboard),
      ),
      RetailPage.reports => ReportsScreen(
        onBack: () => onNavigate(RetailPage.dashboard),
      ),
      RetailPage.settings => SettingsScreen(
        onNavigate: onNavigate,
        onBack: () => onNavigate(RetailPage.dashboard),
      ),
      RetailPage.offline => OfflineScreen(
        sync: sync,
        onBack: () => onNavigate(RetailPage.dashboard),
      ),
      RetailPage.businessProfile => BusinessProfileScreen(
        onBack: () => onNavigate(RetailPage.settings),
        onThemeChanged: onThemeChanged,
      ),
    };
  }
}
