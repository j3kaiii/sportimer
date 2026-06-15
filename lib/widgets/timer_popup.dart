import 'package:flutter/material.dart';
import 'package:sportimer/application/theme.dart';
import 'package:sportimer/models/timer_item/timer_item.dart';
import 'package:sportimer/utils/context_extension.dart';

class TimerPopup extends StatefulWidget {
  const TimerPopup({super.key});

  static Future<TimerAddResult?> show(BuildContext context) {
    return showModalBottomSheet<TimerAddResult>(
      context: context,
      backgroundColor: SportimerThemeData.kBgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => const TimerPopup(),
    );
  }

  @override
  State<TimerPopup> createState() => _TimerPopupState();
}

class _TimerPopupState extends State<TimerPopup> {
  int _minutes = 2;
  int _seconds = 0;
  bool _isRest = false;
  Difficulty _difficulty = Difficulty.medium;

  void _save() {
    Navigator.of(context).pop(TimerAddResult(
      seconds: _minutes * 60 + _seconds,
      isRest: _isRest,
      difficulty: _difficulty,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: mediaQuery.viewInsets.bottom + mediaQuery.padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.textMuted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text('Новый таймер', style: theme.popupTitleStyle),
          const SizedBox(height: 24),
          _buildTimePicker(theme),
          const SizedBox(height: 24),
          _buildRestToggle(theme),
          const SizedBox(height: 20),
          _buildDifficultySection(theme),
          const SizedBox(height: 20),
          _buildSaveButton(theme),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildTimePicker(SportimerThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TimeColumn(
          value: _minutes,
          label: 'Мин',
          theme: theme,
          onIncrement: () => setState(() {
            if (_minutes < 99) _minutes++;
          }),
          onDecrement: () => setState(() {
            if (_minutes > 0) _minutes--;
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(':', style: theme.popupTimeSeparatorStyle),
        ),
        _TimeColumn(
          value: _seconds,
          label: 'Сек',
          theme: theme,
          onIncrement: () => setState(() {
            if (_seconds < 59) {
              _seconds++;
            } else {
              _seconds = 0;
            }
          }),
          onDecrement: () => setState(() {
            if (_seconds > 0) {
              _seconds--;
            } else {
              _seconds = 59;
            }
          }),
        ),
      ],
    );
  }

  Widget _buildRestToggle(SportimerThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.borderColor.withValues(alpha: 0.5)),
          bottom: BorderSide(color: theme.borderColor.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Отдых', style: theme.popupToggleTitleStyle),
              const SizedBox(height: 2),
              Text(
                'Переключить на интервал отдыха',
                style: theme.popupToggleHintStyle,
              ),
            ],
          ),
          GestureDetector(
            onTap: () => setState(() => _isRest = !_isRest),
            child: Container(
              width: 52,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: _isRest ? theme.accentRest : theme.borderColor,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment:
                    _isRest ? Alignment.centerRight : Alignment.centerLeft,
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

  Widget _buildDifficultySection(SportimerThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Сложность', style: theme.popupSectionTitleStyle),
          const SizedBox(height: 10),
          Row(
            children: Difficulty.values.map((d) {
              final active = d == _difficulty;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _difficulty = d),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:
                          active ? theme.accentWorkoutSoft : Colors.transparent,
                      border: Border.all(
                        color:
                            active ? theme.activeItemColor : theme.borderColor,
                      ),
                    ),
                    child: Text(
                      d.name,
                      style: theme.popupChipTextStyle.copyWith(
                        color: active
                            ? theme.activeItemColor
                            : theme.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(SportimerThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: SportimerThemeData.workoutGradient,
          ),
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Сохранить', style: theme.popupSaveTextStyle),
          ),
        ),
      ),
    );
  }
}

class _TimeColumn extends StatelessWidget {
  final int value;
  final String label;
  final SportimerThemeData theme;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _TimeColumn({
    required this.value,
    required this.label,
    required this.theme,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onIncrement,
          child: Container(
            width: 32,
            height: 24,
            alignment: Alignment.center,
            child: Icon(
              Icons.keyboard_arrow_up,
              size: 20,
              color: theme.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 72,
          height: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.coloredBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.borderColor.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: theme.popupTimeValueStyle,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onDecrement,
          child: Container(
            width: 32,
            height: 24,
            alignment: Alignment.center,
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: theme.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: theme.popupTimeLabelStyle),
      ],
    );
  }
}

class TimerAddResult {
  final int seconds;
  final bool isRest;
  final Difficulty difficulty;

  TimerAddResult({
    required this.seconds,
    required this.isRest,
    required this.difficulty,
  });
}
