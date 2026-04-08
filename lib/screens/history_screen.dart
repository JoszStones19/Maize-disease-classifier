import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../models/scan_record.dart';
import '../providers/history_provider.dart';
import '../providers/scan_provider.dart';
import '../widgets/history_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = 'All';

  List<ScanRecord> _applyFilter(List<ScanRecord> records) {
    switch (_filter) {
      case 'Diseased':
        return records.where((item) => item.result.disease != 'healthy').toList();
      case 'Healthy':
        return records.where((item) => item.result.disease == 'healthy').toList();
      default:
        return records;
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryProvider>();
    final records = _applyFilter(historyProvider.history);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan history'),
        actions: [
          if (historyProvider.history.isNotEmpty)
            TextButton(
              onPressed: () async {
                await context.read<HistoryProvider>().clearHistory();
              },
              child: const Text('Clear all', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      bottomNavigationBar: const _BottomNav(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              children: [
                for (final item in const ['All', 'Diseased', 'Healthy'])
                  ChoiceChip(
                    label: Text(item),
                    selected: _filter == item,
                    onSelected: (_) => setState(() => _filter = item),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: records.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.history_toggle_off, size: 56, color: AppColors.mutedText),
                          const SizedBox(height: 12),
                          Text('No scans yet', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 6),
                          Text(
                            'Your previous maize scans will appear here.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: records.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final record = records[index];
                        return HistoryItem(
                          record: record,
                          onTap: () {
                            context.read<ScanProvider>().loadRecord(record);
                            context.push('/results', extra: record);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
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
