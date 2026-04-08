import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/api_constants.dart';
import '../constants/diseases.dart';
import '../constants/theme.dart';
import '../providers/history_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryProvider>();
    final mostScannedKey = historyProvider.mostScannedDisease;
    final mostScannedName = DiseaseConstants.diseases[mostScannedKey]?.name ?? mostScannedKey;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      bottomNavigationBar: const _BottomNav(currentIndex: 3),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.surfaceGreen,
            child: Icon(Icons.person_outline, size: 42, color: AppColors.forest),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text('Farmer profile', style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _StatCard(label: 'Total scans', value: '${historyProvider.totalScans}'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(label: 'Diseases found', value: '${historyProvider.diseasesFound}'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _StatCard(label: 'Healthy leaves', value: '${historyProvider.healthyLeaves}'),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Most scanned disease', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(mostScannedName, style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SettingsTile(
            icon: Icons.lan_outlined,
            title: 'Backend server URL',
            subtitle: historyProvider.backendUrlOverride ?? ApiConstants.baseUrl,
            onTap: () => _showBackendUrlDialog(context, historyProvider),
          ),
          _NotificationTile(provider: historyProvider),
          _SettingsTile(
            icon: Icons.upload_file_outlined,
            title: 'Export history',
            subtitle: 'Save scan history as JSON file',
            onTap: () async {
              final path = await historyProvider.exportHistory();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('History exported to: $path')),
                );
              }
            },
          ),
          _SettingsTile(
            icon: Icons.delete_outline,
            title: 'Clear scan history',
            subtitle: 'Remove all stored local scan records',
            iconColor: AppColors.red,
            onTap: () async {
              await historyProvider.clearHistory();
            },
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              'Version 1.0.0 • Mock mode: ${ApiConstants.mockMode ? 'ON' : 'OFF'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showBackendUrlDialog(
    BuildContext context,
    HistoryProvider historyProvider,
  ) async {
    final controller = TextEditingController(
      text: historyProvider.backendUrlOverride ?? ApiConstants.baseUrl,
    );

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backend server URL'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'http://192.168.x.x:5000',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              await historyProvider.setBackendUrlOverride(controller.text.trim());
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor ?? AppColors.forest),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.provider});

  final HistoryProvider provider;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: SwitchListTile(
        value: provider.notificationsEnabled,
        onChanged: (value) => provider.setNotificationsEnabled(value),
        title: const Text('Notifications'),
        subtitle: const Text('Toggle scan reminders and future alerts'),
        secondary: const Icon(Icons.notifications_none, color: AppColors.forest),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/history');
            break;
          case 2:
            context.go('/guide');
            break;
          case 3:
            context.go('/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Guide'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}
