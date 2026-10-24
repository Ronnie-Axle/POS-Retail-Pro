import 'package:flutter/material.dart';

import '../app_state.dart';
import 'shared_widgets.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({
    required this.cart,
    required this.onBack,
    required this.onCheckout,
    super.key,
  });

  final CartBloc cart;
  final VoidCallback onBack;
  final VoidCallback onCheckout;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _category = 'All';
  String _query = '';
  static const categories = ['All', 'Beverages', 'Snacks', 'Groceries'];

  @override
  Widget build(BuildContext context) {
    final products = sampleProducts.where((product) {
      final matchesCategory =
          _category == 'All' || product.category == _category;
      final matchesQuery = product.name.toLowerCase().contains(
        _query.toLowerCase(),
      );
      return matchesCategory && matchesQuery;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: widget.onBack),
        title: const Text('New Sale'),
        actions: [
          IconButton(
            onPressed: () =>
                showAppMessage(context, 'Checkout securely when ready'),
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(
            height: 56,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                return FilterPill(
                  label: category,
                  selected: _category == category,
                  onTap: () => setState(() => _category = category),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) => ProductTile(
                product: products[index],
                action: IconButton.filled(
                  onPressed: () => widget.cart.add(products[index]),
                  icon: const Icon(Icons.add),
                  iconSize: 20,
                  constraints: const BoxConstraints.tightFor(
                    width: 38,
                    height: 38,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: widget.cart,
        builder: (context, _) => widget.cart.quantities.isEmpty
            ? const SizedBox.shrink()
            : SafeArea(
                minimum: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: ElevatedButton(
                  onPressed: widget.onCheckout,
                  child: Text(
                    'View Cart (${widget.cart.quantities.values.fold<int>(0, (sum, count) => sum + count)})'
                    '  •  ${formatCurrency(widget.cart.subtotal)}',
                  ),
                ),
              ),
      ),
    );
  }
}
