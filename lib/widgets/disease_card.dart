import 'package:flutter/material.dart';

import '../constants/theme.dart';
import '../models/disease.dart';

class DiseaseCard extends StatelessWidget {
  const DiseaseCard({super.key, required this.disease});

  final Disease disease;

  Color get _severityColor {
    switch (disease.severity) {
      case 'high':
        return AppColors.red;
      case 'medium':
        return AppColors.amber;
      default:
        return AppColors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        title: Text(disease.name, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(disease.scientificName, style: Theme.of(context).textTheme.bodySmall),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _severityColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            disease.severity.toUpperCase(),
            style: TextStyle(color: _severityColor, fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ),
        children: [
          _InfoLine(label: 'Type', value: disease.type),
          _InfoLine(label: 'Description', value: disease.description),
          _InfoLine(label: 'Treatment', value: disease.treatment),
          _InfoLine(label: 'Prevention', value: disease.prevention),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
