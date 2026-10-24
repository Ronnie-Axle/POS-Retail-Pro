import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme/app_theme.dart';
import 'shared_widgets.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    required this.cart,
    required this.sync,
    required this.onBack,
    required this.onComplete,
    super.key,
  });

  final CartBloc cart;
  final SyncBloc sync;
  final VoidCallback onBack;
  final VoidCallback onComplete;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;
  bool _processing = false;
  static const methods = [
    ('Cash', Icons.payments_outlined, Color(0xFF16A34A)),
    ('Credit / Debit Card', Icons.credit_card_rounded, AppTheme.primary),
    (
      'Mobile Money (MTN/Airtel)',
      Icons.phone_android_rounded,
      Color(0xFFD39700),
    ),
    ('Bank Transfer', Icons.account_balance_outlined, AppTheme.navy),
  ];

  Future<void> _pay() async {
    setState(() => _processing = true);
    if (!widget.sync.isOnline) {
      widget.sync.queueSale(widget.cart.total);
    }
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    widget.cart.clear();
    showAppMessage(
      context,
      widget.sync.isOnline
          ? 'Payment completed'
          : 'Sale queued for sync while offline',
    );
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: widget.onBack),
        title: const Text('Payment'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 26),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 8),
                      AnimatedBuilder(
                        animation: widget.cart,
                        builder: (context, _) => Text(
                          formatCurrency(widget.cart.total),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const SectionHeading(title: 'Select Payment Method'),
                const SizedBox(height: 10),
                ...List.generate(methods.length, (index) {
                  final method = methods[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () => setState(() => _selectedMethod = index),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedMethod == index
                                ? AppTheme.primary
                                : AppTheme.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: method.$3.withValues(alpha: .12),
                              child: Icon(
                                method.$2,
                                color: method.$3,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                method.$1,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              _selectedMethod == index
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: _selectedMethod == index
                                  ? AppTheme.primary
                                  : AppTheme.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: ElevatedButton(
              onPressed: _processing ? null : _pay,
              child: Text(_processing ? 'Processing...' : 'Pay Now'),
            ),
          ),
        ],
      ),
    );
  }
}
