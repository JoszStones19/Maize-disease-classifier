import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/diseases.dart';
import '../constants/theme.dart';
import '../models/scan_record.dart';
import '../widgets/confidence_bar.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.record});

  final ScanRecord record;

  bool get _isHealthy => record.result.disease == 'healthy';

  @override
  Widget build(BuildContext context) {
    final disease = DiseaseConstants.diseases[record.result.disease]!;
    final badgeColor = _isHealthy ? AppColors.green : AppColors.red;

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(record.imagePath),
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 88,
                    height: 88,
                    color: AppColors.surfaceGreen,
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Latest diagnosis based on the scanned maize leaf.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _isHealthy ? 'Healthy' : 'Disease detected',
                      style: TextStyle(color: badgeColor, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(disease.name, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 6),
                  Text(
                    '${disease.scientificName} • ${disease.type}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  ConfidenceBar(value: record.result.confidence, height: 14),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Other possibilities', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  for (final item in record.result.alternatives) ...[
                    Builder(
                      builder: (context) {
                        final alternative = DiseaseConstants.diseases[item.label];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alternative?.name ?? item.label,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              ConfidenceBar(value: item.confidence, showLabel: false),
                              const SizedBox(height: 4),
                              Text(
                                '${(item.confidence * 100).toStringAsFixed(0)}%',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoCard(title: 'About this disease', content: disease.description),
          const SizedBox(height: AppSpacing.md),
          Card(
            color: const Color(0xFFFFF8E1),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Treatment recommendation', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Text(disease.treatment, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 14),
                  Text('Prevention', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(disease.prevention, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: const Text('New scan'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    context.go('/history');
                  },
                  child: const Text('View history'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text(content, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
