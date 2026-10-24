import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme/app_theme.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: Theme.of(context).textTheme.titleMedium
        ?.copyWith(fontWeight: FontWeight.w700),
  );
}

class FilterPill extends StatelessWidget {
  const FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ChoiceChip(
    label: Text(label),
    selected: selected,
    onSelected: (_) => onTap(),
    showCheckmark: false,
    labelStyle: TextStyle(
      color: selected ? Colors.white : AppTheme.textMuted,
      fontWeight: FontWeight.w600,
      fontSize: 13,
    ),
    backgroundColor: const Color(0xFFF1F5F9),
    selectedColor: AppTheme.primary,
    side: BorderSide.none,
    shape: const StadiumBorder(),
  );
}

class ProductTile extends StatelessWidget {
  const ProductTile({required this.product, required this.action, super.key});

  final Product product;
  final Widget action;

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
        ProductImage(product: product, size: 52),
        const SizedBox(width: 12),
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
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Stock: ${product.stock}',
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        action,
      ],
    ),
  );
}

class ProductImage extends StatelessWidget {
  const ProductImage({required this.product, this.size = 48, super.key});

  final Product product;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Color(product.color).withValues(alpha: .12),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(product.icon, color: Color(product.color), size: size * .55),
  );
}

String formatCurrency(int amount) {
  final digits = amount.toString();
  final formatted = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) formatted.write(',');
    formatted.write(digits[i]);
  }
  return 'UGX $formatted';
}

void showAppMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
