import 'package:flutter/material.dart';

import '../constants/theme.dart';

class ConfidenceBar extends StatelessWidget {
  const ConfidenceBar({
    super.key,
    required this.value,
    this.height = 10,
    this.showLabel = true,
  });

  final double value;
  final double height;
  final bool showLabel;

  Color get _barColor {
    if (value >= 0.85) return AppColors.red;
    if (value >= 0.60) return AppColors.amber;
    return AppColors.green;
  }

  @override
  Widget build(BuildContext context) {
    final safeValue = value.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: safeValue),
            duration: const Duration(milliseconds: 900),
            builder: (context, animatedValue, _) {
              return LinearProgressIndicator(
                value: animatedValue,
                minHeight: height,
                backgroundColor: AppColors.surfaceGreen,
                valueColor: AlwaysStoppedAnimation<Color>(_barColor),
              );
            },
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 8),
          Text(
            '${(safeValue * 100).toStringAsFixed(0)}% confidence',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
