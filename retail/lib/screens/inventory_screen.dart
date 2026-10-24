import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme/app_theme.dart';
import 'shared_widgets.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({
    required this.inventory,
    required this.onBack,
    super.key,
  });

  final InventoryBloc inventory;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    const labels = ['Stock', 'Low Stock', 'Categories'];
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: onBack),
        title: const Text('Inventory'),
      ),
      body: AnimatedBuilder(
        animation: inventory,
        builder: (context, _) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF3F8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: List.generate(labels.length, (index) {
                    final filter = InventoryFilter.values[index];
                    final selected = inventory.filter == filter;
                    return Expanded(
                      child: InkWell(
                        onTap: () => inventory.setFilter(filter),
                        borderRadius: BorderRadius.circular(9),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppTheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            labels[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : AppTheme.textMuted,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: TextField(
                onChanged: inventory.setQuery,
                decoration: const InputDecoration(
                  hintText: 'Search inventory...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: inventory.visibleProducts.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final product = inventory.visibleProducts[index];
                  return ProductTile(
                    product: product,
                    action: const Icon(
                      Icons.chevron_right,
                      color: AppTheme.textMuted,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAppMessage(context, 'New inventory item'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
