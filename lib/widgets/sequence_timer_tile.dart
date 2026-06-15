import 'package:flutter/material.dart';
import 'package:sportimer/utils/context_extension.dart';

class SequenceTimerTile extends StatelessWidget {
  final int seconds;
  final bool isRest;
  final String? difficulty;
  final VoidCallback? onTap;

  const SequenceTimerTile({
    super.key,
    required this.seconds,
    this.isRest = false,
    this.difficulty,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final bgColor = isRest ? theme.accentRestSoft : theme.accentWorkoutSoft;
    final borderColor = isRest
        ? theme.accentRest.withValues(alpha: 0.2)
        : theme.activeItemColor.withValues(alpha: 0.2);
    final iconBg = isRest
        ? theme.accentRest.withValues(alpha: 0.2)
        : theme.activeItemColor.withValues(alpha: 0.2);
    final typeColor = isRest ? theme.accentRest : theme.activeItemColor;
    final typeLabel = isRest ? 'ОТДЫХ' : 'ТРЕНИРОВКА';

    final m = seconds ~/ 60;
    final s = seconds % 60;
    final formatted = '$m:${s.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.timer_outlined,
                  color: typeColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      typeLabel,
                      style: theme.timerTypeStyle.copyWith(color: typeColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatted,
                      style: theme.timerDurationStyle.copyWith(
                        color: theme.textPrimary,
                      ),
                    ),
                    if (difficulty != null && !isRest) ...[
                      const SizedBox(height: 2),
                      Text(
                        difficulty!,
                        style: theme.timerDifficultyStyle,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
