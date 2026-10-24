import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.onNavigate,
    required this.onBack,
    super.key,
  });

  final ValueChanged<RetailPage> onNavigate;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    const settings = [
      ('Business Profile', Icons.business_outlined, RetailPage.businessProfile),
      ('Payment Settings', Icons.credit_card_outlined, RetailPage.payment),
      ('Inventory Settings', Icons.inventory_2_outlined, RetailPage.inventory),
      ('User Management', Icons.people_outline, RetailPage.customers),
      ('App Preferences', Icons.tune_rounded, RetailPage.businessProfile),
      ('Security & Privacy', Icons.shield_outlined, RetailPage.login),
      ('About', Icons.info_outline, RetailPage.offline),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: onBack),
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFFE8EEF7),
                  child: Icon(
                    Icons.person,
                    color: AppTheme.textMuted,
                    size: 30,
                  ),
                ),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Business Owner',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'owner@business.com',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...settings.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppTheme.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: Icon(item.$2, color: AppTheme.textMuted),
                  title: Text(
                    item.$1,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppTheme.textMuted,
                  ),
                  onTap: () => onNavigate(item.$3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
