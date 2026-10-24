import 'dart:math';

import 'package:flutter/material.dart';

enum RetailPage {
  welcome,
  login,
  dashboard,
  catalog,
  checkout,
  payment,
  inventory,
  customers,
  reports,
  settings,
  offline,
  businessProfile,
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.reorderAt,
    required this.category,
    required this.icon,
    required this.color,
  });

  final String id;
  final String name;
  final int price;
  final int stock;
  final int reorderAt;
  final String category;
  final IconData icon;
  final int color;
}

const List<Product> sampleProducts = [
  Product(
    id: 'coke',
    name: 'Coca Cola 500ml',
    price: 2500,
    stock: 50,
    reorderAt: 20,
    category: 'Beverages',
    icon: Icons.local_drink_rounded,
    color: 0xFFE94848,
  ),
  Product(
    id: 'sprite',
    name: 'Sprite 500ml',
    price: 2500,
    stock: 40,
    reorderAt: 20,
    category: 'Beverages',
    icon: Icons.local_drink_rounded,
    color: 0xFF24A76A,
  ),
  Product(
    id: 'water',
    name: 'Water 500ml',
    price: 1500,
    stock: 100,
    reorderAt: 30,
    category: 'Beverages',
    icon: Icons.water_drop_rounded,
    color: 0xFF3897DC,
  ),
  Product(
    id: 'bread',
    name: 'Bread',
    price: 3000,
    stock: 30,
    reorderAt: 10,
    category: 'Groceries',
    icon: Icons.bakery_dining_rounded,
    color: 0xFFC18A4A,
  ),
  Product(
    id: 'chips',
    name: 'Chips',
    price: 2000,
    stock: 45,
    reorderAt: 15,
    category: 'Snacks',
    icon: Icons.fastfood_rounded,
    color: 0xFFE9A72E,
  ),
];

class CartBloc extends ChangeNotifier {
  final Map<String, int> _quantities = {'coke': 2, 'chips': 1};

  Map<String, int> get quantities => Map.unmodifiable(_quantities);

  List<Product> get products => sampleProducts
      .where((product) => _quantities.containsKey(product.id))
      .toList(growable: false);

  int get subtotal => products.fold(
    0,
    (sum, product) => sum + product.price * _quantities[product.id]!,
  );

  int get tax => (subtotal * 0.18).round();

  int get total => subtotal + tax;

  int quantityFor(String productId) => _quantities[productId] ?? 0;

  void add(Product product) {
    _quantities.update(
      product.id,
      (quantity) => quantity + 1,
      ifAbsent: () => 1,
    );
    notifyListeners();
  }

  void remove(String productId) {
    final quantity = _quantities[productId];
    if (quantity == null) return;
    if (quantity <= 1) {
      _quantities.remove(productId);
    } else {
      _quantities[productId] = quantity - 1;
    }
    notifyListeners();
  }

  void clear() {
    _quantities.clear();
    notifyListeners();
  }
}

enum InventoryFilter { stock, lowStock, categories }

class InventoryBloc extends ChangeNotifier {
  String query = '';
  InventoryFilter filter = InventoryFilter.stock;
  String category = 'All';

  List<Product> get visibleProducts {
    Iterable<Product> products = sampleProducts;
    if (filter == InventoryFilter.lowStock) {
      products = products.where(
        (product) => product.stock <= product.reorderAt,
      );
    }
    if (category != 'All') {
      products = products.where((product) => product.category == category);
    }
    if (query.isNotEmpty) {
      products = products.where(
        (product) => product.name.toLowerCase().contains(query.toLowerCase()),
      );
    }
    return products.toList(growable: false);
  }

  void setQuery(String value) {
    query = value;
    notifyListeners();
  }

  void setFilter(InventoryFilter value) {
    filter = value;
    notifyListeners();
  }

  void setCategory(String value) {
    category = value;
    notifyListeners();
  }
}

class PendingSale {
  const PendingSale({required this.idempotencyKey, required this.total});

  final String idempotencyKey;
  final int total;
}

class SyncBloc extends ChangeNotifier {
  bool isOnline = true;
  final List<PendingSale> _pendingSales = [];

  List<PendingSale> get pendingSales => List.unmodifiable(_pendingSales);
  int get pendingCount => _pendingSales.length;

  void setOnline(bool value) {
    isOnline = value;
    notifyListeners();
  }

  String queueSale(int total) {
    final key = _uuidV4();
    _pendingSales.add(PendingSale(idempotencyKey: key, total: total));
    notifyListeners();
    return key;
  }

  String _uuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0'));
    final value = hex.join();
    return '${value.substring(0, 8)}-${value.substring(8, 12)}-'
        '${value.substring(12, 16)}-${value.substring(16, 20)}-'
        '${value.substring(20)}';
  }
}
