import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'shared_widgets.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  static const customers = [
    ('John Mwangi', '+256 700 123 456'),
    ('Sarah Nakato', '+256 772 987 654'),
    ('David Kato', '+256 703 456 789'),
    ('Aisha Namulindea', '+256 751 234 567'),
    ('Peter Ssemanda', '+256 788 765 432'),
  ];
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final visible = customers
        .where(
          (customer) =>
              customer.$1.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: widget.onBack),
        title: const Text('Customers'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(
                hintText: 'Search customers...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: visible.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final customer = visible[index];
                final initials = customer.$1
                    .split(' ')
                    .take(2)
                    .map((part) => part[0])
                    .join();
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFE8EEF7),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: AppTheme.navy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  title: Text(
                    customer.$1,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(customer.$2),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppTheme.textMuted,
                  ),
                  onTap: () => showAppMessage(context, customer.$1),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: ElevatedButton(
          onPressed: () => showAppMessage(context, 'Add customer'),
          child: const Text('+ Add Customer'),
        ),
      ),
    );
  }
}
