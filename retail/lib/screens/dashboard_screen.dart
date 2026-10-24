import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme/app_theme.dart';
import 'shared_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    required this.onNavigate,
    required this.sync,
    super.key,
  });

  final ValueChanged<RetailPage> onNavigate;
  final SyncBloc sync;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Good Morning,',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Business Owner',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      showAppMessage(context, 'No new notifications'),
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
                GestureDetector(
                  onTap: () => onNavigate(RetailPage.settings),
                  child: const CircleAvatar(
                    backgroundColor: Color(0xFFE8EEF7),
                    child: Icon(Icons.person, color: AppTheme.textMuted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _SalesCard(onTap: () => onNavigate(RetailPage.reports)),
            const SizedBox(height: 24),
            const SectionHeading(title: 'Quick Actions'),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.65,
              children: [
                _QuickAction(
                  icon: Icons.shopping_cart_outlined,
                  label: 'New Sale',
                  onTap: () => onNavigate(RetailPage.catalog),
                ),
                _QuickAction(
                  icon: Icons.inventory_2_outlined,
                  label: 'Inventory',
                  onTap: () => onNavigate(RetailPage.inventory),
                ),
                _QuickAction(
                  icon: Icons.people_outline_rounded,
                  label: 'Customers',
                  onTap: () => onNavigate(RetailPage.customers),
                ),
                _QuickAction(
                  icon: Icons.bar_chart_rounded,
                  label: 'Reports',
                  onTap: () => onNavigate(RetailPage.reports),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(
                  child: SectionHeading(title: 'Recent Transactions'),
                ),
                TextButton(
                  onPressed: () => onNavigate(RetailPage.reports),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const _TransactionTile(
              icon: Icons.payments_outlined,
              title: 'Cash Sale',
              amount: 'UGX 45,000',
              time: '10:24 AM',
              tint: Color(0xFFDCFCE7),
              iconColor: Color(0xFF16A34A),
            ),
            const _TransactionTile(
              icon: Icons.credit_card_rounded,
              title: 'Card Payment',
              amount: 'UGX 120,000',
              time: '09:50 AM',
              tint: Color(0xFFDBEAFE),
              iconColor: AppTheme.primary,
            ),
            const _TransactionTile(
              icon: Icons.phone_android_rounded,
              title: 'Mobile Money',
              amount: 'UGX 80,000',
              time: '09:15 AM',
              tint: Color(0xFFFFF7D6),
              iconColor: Color(0xFFD39700),
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: sync,
              builder: (context, _) => OutlinedButton.icon(
                onPressed: () => onNavigate(RetailPage.offline),
                icon: Icon(
                  sync.isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                  size: 18,
                ),
                label: Text(
                  sync.isOnline
                      ? 'Online • ${sync.pendingCount} pending'
                      : 'Working Offline • ${sync.pendingCount} pending',
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavigation(
        selected: 0,
        onSelected: (index) => onNavigate(switch (index) {
          0 => RetailPage.dashboard,
          1 => RetailPage.catalog,
          2 => RetailPage.inventory,
          3 => RetailPage.customers,
          _ => RetailPage.settings,
        }),
      ),
    );
  }
}

class _SalesCard extends StatelessWidget {
  const _SalesCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF1548B8)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Sales",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'UGX 1,250,000',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(color: Colors.white, fontSize: 24),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '↑ 12%',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const SizedBox(width: 90, height: 68, child: _MiniBars()),
        ],
      ),
    ),
  );
}

class _MiniBars extends StatelessWidget {
  const _MiniBars();

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: const [
      _Bar(height: 24),
      _Bar(height: 40),
      _Bar(height: 30),
      _Bar(height: 55),
      _Bar(height: 44),
    ],
  );
}

class _Bar extends StatelessWidget {
  const _Bar({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) => Container(
    width: 10,
    height: height,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .72),
      borderRadius: BorderRadius.circular(4),
    ),
  );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primary),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    required this.icon,
    required this.title,
    required this.amount,
    required this.time,
    required this.tint,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final String amount;
  final String time;
  final Color tint;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppTheme.border)),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: tint,
          child: Icon(icon, color: iconColor, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 3),
              Text(
                time,
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
        Text(amount, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({required this.selected, required this.onSelected});

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: selected,
    onDestinationSelected: onSelected,
    destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
      NavigationDestination(
        icon: Icon(Icons.point_of_sale_outlined),
        label: 'Sales',
      ),
      NavigationDestination(
        icon: Icon(Icons.inventory_2_outlined),
        label: 'Inventory',
      ),
      NavigationDestination(
        icon: Icon(Icons.people_outline),
        label: 'Customers',
      ),
      NavigationDestination(icon: Icon(Icons.more_horiz), label: 'More'),
    ],
  );
}
