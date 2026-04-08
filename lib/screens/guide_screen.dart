import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/diseases.dart';
import '../constants/theme.dart';
import '../widgets/disease_card.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final diseases = DiseaseConstants.diseases.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Disease guide')),
      bottomNavigationBar: const _BottomNav(currentIndex: 2),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          ...diseases.map(
            (disease) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DiseaseCard(disease: disease),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: AppColors.surfaceGreen,
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Disclaimer: This app supports field screening and research demonstration. It does not replace expert agronomic or laboratory diagnosis.',
              ),
            ),
          ),
        ],
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
