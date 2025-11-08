import 'package:flutter/material.dart';
import 'package:sportimer/models/timer_item/timer_item.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class TimerPopup extends StatefulWidget {
  const TimerPopup({super.key});

  @override
  State<TimerPopup> createState() => _TimerPopupState();
}

class _TimerPopupState extends State<TimerPopup> {
  int minutes = 0;
  int seconds = 0;
  final FixedExtentScrollController _minutesController =
      FixedExtentScrollController();
  final FixedExtentScrollController _secondsController =
      FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    _minutesController.jumpToItem(0);
    _secondsController.jumpToItem(0);
  }

  @override
  void dispose() {
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _confirmSelection() {
    Navigator.of(context).pop(TimerData(min: minutes, sec: seconds));
  }

  void _cancelSelection() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set Timer Duration',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSpiner(
                  context,
                  _minutesController,
                  (value) => setState(() {
                    minutes = int.parse(value);
                  }),
                ),
                const Text(
                  ':',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                _buildSpiner(
                  context,
                  _secondsController,
                  (value) => setState(() {
                    seconds = int.parse(value);
                  }),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Preview of selected time
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _cancelSelection,
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _confirmSelection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Set Timer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpiner(
    BuildContext context,
    FixedExtentScrollController controller,
    void Function(dynamic)? onChange,
  ) {
    return SizedBox(
      width: 100,
      height: 200,
      child: WheelChooser<int>(
        onValueChanged: onChange,
        datas: List.generate(60, (index) => index.toString().padLeft(2, '0')),
        isInfinite: true,
        controller: controller,
        startPosition: null,
      ),
    );
  }
}
