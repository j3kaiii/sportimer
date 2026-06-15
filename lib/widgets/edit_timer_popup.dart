import 'package:flutter/material.dart';
import 'package:sportimer/application/theme.dart';
import 'package:sportimer/models/timer_item/timer_item.dart';
import 'package:sportimer/utils/context_extension.dart';

class EditTimerPopup extends StatefulWidget {
  final int initialSeconds;

  const EditTimerPopup({super.key, required this.initialSeconds});

  @override
  State<EditTimerPopup> createState() => _EditTimerPopupState();
}

class _EditTimerPopupState extends State<EditTimerPopup> {
  late int _minutes;
  late int _seconds;

  @override
  void initState() {
    super.initState();
    _minutes = widget.initialSeconds ~/ 60;
    _seconds = widget.initialSeconds % 60;
  }

  void _save() {
    Navigator.of(context).pop(TimerData(min: _minutes, sec: _seconds));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final loc = context.loc;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(loc.setTimerTitle, style: theme.popupTitleStyle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeColumn(
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
              _buildTimeColumn(
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
          ),
          const SizedBox(height: 16),
          Text(
            '${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
            style: theme.popupTimeValueStyle.copyWith(
              fontSize: 24,
              color: theme.activeItemColor,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(loc.btnCancel),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.activeItemColor,
            foregroundColor: Colors.white,
          ),
          child: Text(loc.btnSave),
        ),
      ],
    );
  }

  Widget _buildTimeColumn({
    required int value,
    required String label,
    required SportimerThemeData theme,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onIncrement,
          child: Icon(Icons.keyboard_arrow_up, color: theme.textMuted),
        ),
        const SizedBox(height: 4),
        Container(
          width: 64,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.coloredBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: theme.popupTimeValueStyle.copyWith(fontSize: 22),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onDecrement,
          child: Icon(Icons.keyboard_arrow_down, color: theme.textMuted),
        ),
        const SizedBox(height: 2),
        Text(label, style: theme.popupTimeLabelStyle),
      ],
    );
  }
}
