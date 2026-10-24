import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme/app_theme.dart';
import 'shared_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    required this.cart,
    required this.onBack,
    required this.onPay,
    super.key,
  });

  final CartBloc cart;
  final VoidCallback onBack;
  final VoidCallback onPay;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _paymentMethod = 'Cash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: widget.onBack),
        title: const Text('New Sale'),
      ),
      body: AnimatedBuilder(
        animation: widget.cart,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_outline, color: AppTheme.textMuted),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Walk-in Customer',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        showAppMessage(context, 'Customer selection'),
                    child: const Text('Change'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ...widget.cart.products.map(
              (product) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _CartRow(
                  product: product,
                  quantity: widget.cart.quantityFor(product.id),
                  onDecrease: () => widget.cart.remove(product.id),
                  onIncrease: () => widget.cart.add(product),
                ),
              ),
            ),
            if (widget.cart.products.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 36),
                child: Center(child: Text('Your cart is empty')),
              ),
            const SizedBox(height: 8),
            _OrderSummary(cart: widget.cart),
            const SizedBox(height: 20),
            const SectionHeading(title: 'Payment Method'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Cash', 'Card', 'Mobile Money']
                  .map(
                    (method) => FilterPill(
                      label: method,
                      selected: _paymentMethod == method,
                      onTap: () => setState(() => _paymentMethod = method),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: widget.cart.products.isEmpty ? null : widget.onPay,
              child: const Text('Complete Sale'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({
    required this.product,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final Product product;
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppTheme.border),
    ),
    child: Row(
      children: [
        ProductImage(product: product, size: 48),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                formatCurrency(product.price),
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  _QuantityButton(icon: Icons.remove, onTap: onDecrease),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '$quantity',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  _QuantityButton(icon: Icons.add, onTap: onIncrease),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          formatCurrency(product.price * quantity),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    ),
  );
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(7),
    child: Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Icon(icon, size: 16),
    ),
  );
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.cart});

  final CartBloc cart;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppTheme.border),
    ),
    child: Column(
      children: [
        _SummaryRow(label: 'Subtotal', value: formatCurrency(cart.subtotal)),
        const SizedBox(height: 10),
        _SummaryRow(label: 'Tax (18%)', value: formatCurrency(cart.tax)),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(height: 1),
        ),
        _SummaryRow(
          label: 'Total',
          value: formatCurrency(cart.total),
          bold: true,
        ),
      ],
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            color: bold ? AppTheme.textPrimary : AppTheme.textMuted,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            fontSize: bold ? 16 : 14,
          ),
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          fontSize: bold ? 18 : 14,
        ),
      ),
    ],
  );
}
