import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:sportimer/application/consts.dart';
import 'package:sportimer/application/localizations.dart';
import 'package:sportimer/models/timer_item/timer_item.dart';
import 'package:sportimer/models/timer_sequence/sequence.dart';
import 'package:sportimer/providers/hive_box_provider.dart';
import 'package:sportimer/screens/common_content_screen.dart';
import 'package:sportimer/utils/context_extension.dart';
import 'package:sportimer/widgets/edit_title_popup.dart';
import 'package:sportimer/widgets/list_item.dart';
import 'package:sportimer/widgets/timer_popup.dart';

/// Экран последовательности таймеров.
class SequenceScreen extends StatefulWidget {
  final Sequence sequence;
  const SequenceScreen({super.key, required this.sequence});

  @override
  State<SequenceScreen> createState() => _SequenceScreenState();
}

class _SequenceScreenState extends State<SequenceScreen> {
  late Sequence _currentSequence;
  Box<Sequence>? _sequenceBox;

  @override
  void initState() {
    super.initState();
    _currentSequence = widget.sequence;
  }

  @override
  void didChangeDependencies() {
    _sequenceBox ??= HiveBoxProvider.of(context).sequenceBox;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CommonContentScreen(
        title: _currentSequence.name,
        actions: [
          IconButton(
              onPressed: () => showEditTilePopup(context),
              icon: Icon(Icons.edit))
        ],
        floatingButton: ElevatedButton(
          onPressed: () => context.goNamed(
            runSequenceName,
            extra: widget.sequence,
          ),
          style: context.theme.buttonStyle,
          child:
              Text(context.loc.btnStart, style: context.theme.buttonTextStyle),
        ),
        child: SequenceContent(sequence: widget.sequence));
  }

  Future<void> showEditTilePopup(BuildContext context) async {
    final res = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return EditTitlePopup(title: widget.sequence.name);
      },
    );

    if (res != null && res.isNotEmpty && res != widget.sequence.name) {
      final updatedSequence = widget.sequence.copyWith(res);

      _sequenceBox?.put(updatedSequence.id, updatedSequence);

      if (mounted) {
        setState(() {
          _currentSequence = updatedSequence;
        });
      }
    }
  }
}

class SequenceContent extends StatefulWidget {
  final Sequence sequence;

  const SequenceContent({
    super.key,
    required this.sequence,
  });

  @override
  State<SequenceContent> createState() => _SequenceContentState();
}

class _SequenceContentState extends State<SequenceContent> {
  late final Box<TimerItem> _timersBox;

  @override
  void initState() {
    super.initState();
    _timersBox = Hive.box<TimerItem>(timersBoxName);
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: _timersBox.listenable(),
          builder: ((context, _, __) {
            final items = _timersBox.values
                .where((t) => t.sequenceId == widget.sequence.id)
                .toList();
            items.sort((a, b) => a.position.compareTo(b.position));
            final length = items.length + 1;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: length,
              itemBuilder: (context, index) {
                final next = index + 1;
                if (next == length) {
                  return _buildAddTimer(context, loc, next);
                }
                final item = items[index];
                return ListItem(
                  name: item.displayAsTime(),
                  onTap: () {},
                );
              },
            );
          }),
        ));
  }

  Future<TimerData?> showTimerPopup(BuildContext context) {
    return showDialog<TimerData>(
      context: context,
      builder: (BuildContext context) {
        return const TimerPopup();
      },
    );
  }

  Widget _buildAddTimer(
      BuildContext context, AppLocalizations loc, int nextPos) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: IconButton.outlined(
        onPressed: () async {
          final value = await showTimerPopup(context);
          if (value != null) {
            final newTimer =
                TimerItem.create(value.toSeconds, nextPos, widget.sequence.id);
            _addTimer(newTimer);
          }
        },
        icon: const Icon(Icons.add, color: Colors.blueAccent),
        iconSize: 46,
      ),
    );
  }

  // При добавлении таймера
  void _addTimer(TimerItem newTimer) {
    _timersBox.put(newTimer.id, newTimer);
  }
}
