import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sportimer/application/consts.dart';
import 'package:sportimer/application/localizations.dart';
import 'package:sportimer/models/timer_sequence/sequence.dart';
import 'package:sportimer/screens/common_content_screen.dart';
import 'package:sportimer/utils/context_extension.dart';
import 'package:sportimer/widgets/list_item.dart';
import 'package:uuid/v4.dart';

/// Экран списков таймеров.
///
/// Содержит все ранее созданные последовательности таймеров
class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  late final TextEditingController _textController;
  late final Box<Sequence> _sequenceBox;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _sequenceBox = Hive.box<Sequence>(sequenceBoxName);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return CommonContentScreen(
      title: loc.timerListTitle,
      // actions: [
      //   IconButton(
      //       onPressed: () {
      //         print('testdata pressed settings');
      //       },
      //       icon: Icon(Icons.settings))
      // ],
      floatingButton: FloatingActionButton(
        onPressed: () async {
          final next = _sequenceBox.length + 1;
          final sequence =
              Sequence(const UuidV4().generate(), loc.orderedName(next));
          await _sequenceBox.put(sequence.id, sequence);
          if (context.mounted) {
            context.goNamed(sequenceName, extra: sequence);
          }
        },
        child: Icon(
          Icons.add_alarm,
          size: 40,
        ),
      ),
      floatingButtonLocation: FloatingActionButtonLocation.endFloat,
      child: _buildList(context, loc),
    );
  }

  // Перенести на экран создания сиквенции

  // String? _validate(String? input, AppLocalizations loc) {
  //   if (input == null || input.isEmpty) {
  //     return 'error';
  //   } else if (_listsBox.values.any((l) => l.name == input)) {
  //     return 'error';
  //   }
  //   return null;
  // }

  // void _onAddPressed() {
  //   if (_isCreating) {
  //     _validator = _validate(_textController.text, context.loc);
  //     if (_validator == null) {
  //       _listsBox.add(Sequence(_textController.text));
  //       _textController.text = '';
  //       setState(() {
  //         _isCreating = !_isCreating;
  //       });
  //     }
  //   } else {
  //     setState(() {
  //       _isCreating = !_isCreating;
  //     });
  //   }
  // }

  // void _onCancel() {
  //   setState(() {
  //     _textController.text = '';
  //     _validator = null;
  //     _isCreating = !_isCreating;
  //   });
  // }

  Widget _buildList(BuildContext context, AppLocalizations loc) {
    const axisSpacing = 8.0;
    return ValueListenableBuilder(
      valueListenable: _sequenceBox.listenable(),
      builder: ((context, value, _) {
        final lists = value.values.toList();

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: axisSpacing,
              mainAxisSpacing: axisSpacing,
            ),
            itemCount: lists.length,
            itemBuilder: (context, index) => ListItem(
              name: lists[index].name,
              onTap: () => context.goNamed(
                sequenceName,
                extra: lists[index],
              ),
            ),
          ),
        );
      }),
    );
  }
}
