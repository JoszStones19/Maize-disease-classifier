import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../providers/scan_provider.dart';
import '../widgets/upload_zone.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _pickGallery(BuildContext context) async {
    final scanProvider = context.read<ScanProvider>();
    final ok = await scanProvider.pickFromGallery();
    if (ok && context.mounted) {
      context.push('/preview');
    }
  }

  Future<void> _takePhoto(BuildContext context) async {
    final scanProvider = context.read<ScanProvider>();
    final ok = await scanProvider.takePhoto();
    if (ok && context.mounted) {
      context.push('/preview');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _BottomNav(currentIndex: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.forest,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maize Doctor',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Snap a leaf · Get instant diagnosis',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            UploadZone(onTap: () => _pickGallery(context)),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: () => _takePhoto(context),
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Take photo with camera'),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Tips', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            const _TipCard(
              text: 'Capture the full leaf in bright, natural light',
              dotColor: AppColors.green,
            ),
            const SizedBox(height: 12),
            const _TipCard(
              text: 'Focus on the affected area — avoid blurry shots',
              dotColor: AppColors.amber,
            ),
            const SizedBox(height: 12),
            const _TipCard(
              text: 'Use a plain background for cleaner predictions',
              dotColor: AppColors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.text, required this.dotColor});

  final String text;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
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
