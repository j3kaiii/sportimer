import 'package:flutter/material.dart';
import 'package:sportimer/application/theme.dart';
import 'package:sportimer/utils/context_extension.dart';

class RestToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final SportimerThemeData theme;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;

  const RestToggle({
    super.key,
    required this.value,
    required this.onChanged,
    required this.theme,
    this.margin,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.borderColor.withValues(alpha: 0.5)),
          bottom: BorderSide(color: theme.borderColor.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loc.isRestTitle, style: theme.popupToggleTitleStyle),
                const SizedBox(height: 2),
                Text(
                  loc.restToggleHint,
                  style: theme.popupToggleHintStyle,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              width: 52,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: value ? theme.accentRest : theme.borderColor,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
