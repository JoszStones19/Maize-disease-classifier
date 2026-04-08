import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/diseases.dart';
import '../constants/theme.dart';
import '../models/scan_record.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    super.key,
    required this.record,
    required this.onTap,
  });

  final ScanRecord record;
  final VoidCallback onTap;

  Color get _badgeColor {
    if (record.result.disease == 'healthy') return AppColors.green;
    if (record.result.confidence >= 0.85) return AppColors.red;
    if (record.result.confidence >= 0.60) return AppColors.amber;
    return AppColors.green;
  }

  @override
  Widget build(BuildContext context) {
    final disease = DiseaseConstants.diseases[record.result.disease]!;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(record.imagePath),
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 72,
                    height: 72,
                    color: AppColors.surfaceGreen,
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(disease.name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMM yyyy • HH:mm').format(record.scannedAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: _badgeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${(record.result.confidence * 100).toStringAsFixed(0)}%',
                  style: TextStyle(color: _badgeColor, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
