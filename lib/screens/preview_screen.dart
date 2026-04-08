import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../providers/history_provider.dart';
import '../providers/scan_provider.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final scanProvider = context.watch<ScanProvider>();
    final image = scanProvider.selectedImage;

    if (image == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Preview')),
        body: const Center(child: Text('No image selected.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Preview leaf')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: FutureBuilder<FileStat>(
          future: image.stat(),
          builder: (context, snapshot) {
            final stat = snapshot.data;
            final fileName = image.path.split(Platform.pathSeparator).last;
            return ListView(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.file(
                        File(image.path),
                        width: double.infinity,
                        height: 340,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Leaf detected',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text(fileName)),
                    if (stat != null) Chip(label: Text(_formatSize(stat.size))),
                    Chip(
                      label: Text(
                        DateFormat('dd MMM yyyy').format(
                          scanProvider.selectedAt ?? DateTime.now(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: scanProvider.isLoading
                      ? null
                      : () async {
                          final record = await context
                              .read<ScanProvider>()
                              .analyse(context.read<HistoryProvider>());
                          if (record != null && context.mounted) {
                            context.push('/results', extra: record);
                          }
                        },
                  child: scanProvider.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Analyse leaf →'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async {
                    final ok = await context.read<ScanProvider>().pickFromGallery();
                    if (!ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No new image selected.')),
                      );
                    }
                  },
                  child: const Text('Retake / choose different'),
                ),
                if (scanProvider.error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    scanProvider.error!,
                    style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.w700),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
