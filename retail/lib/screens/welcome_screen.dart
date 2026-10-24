import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({required this.onContinue, super.key});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 18),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.shopping_cart_rounded,
                  size: 58,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'POS Retail Pro',
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 10),
              const Text(
                'Manage your business anytime, anywhere',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onContinue,
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Version 1.0.0',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
