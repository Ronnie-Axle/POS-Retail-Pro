import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'shared_widgets.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({
    required this.onBack,
    required this.onThemeChanged,
    super.key,
  });

  final VoidCallback onBack;
  final ValueChanged<int> onThemeChanged;

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  final TextEditingController _businessName = TextEditingController(
    text: 'My Store',
  );
  String _businessType = 'Retail Store';
  int _selectedTheme = 0;

  @override
  void dispose() {
    _businessName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: BackButton(onPressed: widget.onBack),
      title: const Text('Business Profile'),
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        const _FieldLabel('Business Name'),
        TextField(controller: _businessName),
        const SizedBox(height: 16),
        const _FieldLabel('Business Type'),
        DropdownButtonFormField<String>(
          initialValue: _businessType,
          decoration: const InputDecoration(),
          items: const [
            DropdownMenuItem(
              value: 'Retail Store',
              child: Text('Retail Store'),
            ),
            DropdownMenuItem(value: 'Grocery', child: Text('Grocery')),
            DropdownMenuItem(value: 'Restaurant', child: Text('Restaurant')),
            DropdownMenuItem(value: 'Other', child: Text('Other')),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _businessType = value);
          },
        ),
        const SizedBox(height: 18),
        const _FieldLabel('Logo'),
        Row(
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Icon(
                Icons.storefront_outlined,
                size: 36,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(width: 14),
            TextButton(
              onPressed: () =>
                  showAppMessage(context, 'Logo picker is not configured'),
              child: const Text('Change'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const _FieldLabel('Theme Color'),
        const SizedBox(height: 10),
        Row(
          children: List.generate(
            AppTheme.palette.length,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 15),
              child: InkWell(
                onTap: () {
                  setState(() => _selectedTheme = index);
                  widget.onThemeChanged(index);
                },
                customBorder: const CircleBorder(),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedTheme == index
                          ? AppTheme.palette[index]
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: AppTheme.palette[index],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        ElevatedButton(
          onPressed: () {
            showAppMessage(context, 'Business profile saved');
            widget.onBack();
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    ),
  );
}
