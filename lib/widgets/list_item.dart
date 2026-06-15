import 'package:flutter/material.dart';
import 'package:sportimer/application/theme.dart';
import 'package:sportimer/utils/context_extension.dart';

class ListItem extends StatelessWidget {
  final String name;
  final int intervalsCount;
  final String totalDuration;
  final bool isCyclic;
  final bool hasWorkout;
  final bool hasRest;
  final VoidCallback? onTap;

  const ListItem({
    super.key,
    required this.name,
    required this.intervalsCount,
    required this.totalDuration,
    required this.isCyclic,
    this.hasWorkout = true,
    this.hasRest = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final mixed = hasWorkout && hasRest;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.secondaryBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.cardBorderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                gradient: mixed
                    ? SportimerThemeData.mixedGradient
                    : SportimerThemeData.workoutGradient,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.cardTitleStyle,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _MetaItem(
                          icon: Icons.timer_outlined,
                          text: '$intervalsCount интервалов',
                          theme: theme,
                        ),
                        const SizedBox(width: 16),
                        _MetaItem(
                          icon: Icons.schedule,
                          text: totalDuration,
                          theme: theme,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: isCyclic
                            ? theme.cardBadgeCyclicBg
                            : theme.cardBadgeSingleBg,
                      ),
                      child: Text(
                        isCyclic ? 'Цикличный' : 'Однопроходный',
                        style: theme.cardBadgeStyle.copyWith(
                          color: isCyclic
                              ? theme.cardBadgeCyclicColor
                              : theme.cardBadgeSingleColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final SportimerThemeData theme;

  const _MetaItem({
    required this.icon,
    required this.text,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: theme.textMuted),
        const SizedBox(width: 4),
        Text(text, style: theme.cardMetaStyle),
      ],
    );
  }
}
