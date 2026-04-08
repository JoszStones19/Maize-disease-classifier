import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../constants/theme.dart';

class UploadZone extends StatelessWidget {
  const UploadZone({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        color: AppColors.forestSoft,
        strokeWidth: 1.5,
        dashPattern: const [7, 5],
        radius: const Radius.circular(20),
        borderType: BorderType.RRect,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surfaceGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Icon(Icons.cloud_upload_outlined, size: 40, color: AppColors.forest),
              const SizedBox(height: 12),
              Text(
                'Upload leaf image',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'Tap to choose a photo from your gallery',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
