import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme/app_theme.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({required this.sync, required this.onBack, super.key});

  final SyncBloc sync;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: BackButton(onPressed: onBack),
      title: const Text('Offline Mode'),
    ),
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: const BoxDecoration(
                  color: Color(0xFFE9EEF4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  size: 54,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "You're Offline",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const Text(
                'No internet connection detected. You can still process sales, '
                'view cached data and manage inventory.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textMuted, height: 1.5),
              ),
              const SizedBox(height: 22),
              AnimatedBuilder(
                animation: sync,
                builder: (context, _) => Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => sync.setOnline(!sync.isOnline),
                      icon: Icon(
                        sync.isOnline
                            ? Icons.check_circle_outline
                            : Icons.wifi_off_rounded,
                        size: 18,
                      ),
                      label: Text(
                        sync.isOnline ? 'Working Online' : 'Working Offline',
                      ),
                    ),
                    if (sync.pendingCount > 0)
                      Chip(
                        label: Text('${sync.pendingCount} pending sync'),
                        backgroundColor: const Color(0xFFEFF3F8),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
