import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sportimer/application/consts.dart';
import 'package:sportimer/application/localizations.dart';
import 'package:sportimer/models/timer_sequence/sequence.dart';
import 'package:sportimer/screens/common_content_screen.dart';
import 'package:sportimer/utils/context_extension.dart';
import 'package:sportimer/widgets/bottom_panel.dart';
import 'package:sportimer/widgets/list_item.dart';
import 'package:sportimer/widgets/stub.dart';

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
  late final Box<Sequence> _listsBox;
  bool _isCreating = false;
  String? _validator;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _listsBox = Hive.box<Sequence>(listsBoxName);
  }

  @override
  void dispose() {
    _textController.dispose();
    _listsBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final theme = context.theme;
    return CommonContentScreen(
      title: 'timers',
      child: LayoutBuilder(
        builder: (context, cts) {
          return Stack(
            children: [
              _buildList(context, loc),
              if (_isCreating) Container(color: theme.coloredBackground),
              PositionedDirectional(
                end: 8,
                bottom: 8,
                child: BottomPanel(
                  isAdding: _isCreating,
                  onAddPressed: _onAddPressed,
                  onCancel: _onCancel,
                  panelWidth: cts.maxWidth - 46,
                  textController: _textController,
                  validator: (value) => _validate(value, loc),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String? _validate(String? input, AppLocalizations loc) {
    if (input == null || input.isEmpty) {
      return 'error';
    } else if (_listsBox.values.any((l) => l.name == input)) {
      return 'error';
    }
    return null;
  }

  void _onAddPressed() {
    if (_isCreating) {
      _validator = _validate(_textController.text, context.loc);
      if (_validator == null) {
        _listsBox.add(Sequence(_textController.text));
        _textController.text = '';
        setState(() {
          _isCreating = !_isCreating;
        });
      }
    } else {
      setState(() {
        _isCreating = !_isCreating;
      });
    }
  }

  void _onCancel() {
    setState(() {
      _textController.text = '';
      _validator = null;
      _isCreating = !_isCreating;
    });
  }

  Widget _buildList(BuildContext context, AppLocalizations loc) {
    return ValueListenableBuilder(
      valueListenable: _listsBox.listenable(),
      builder: ((context, value, _) {
        final lists = value.values.toList();

        if (lists.isEmpty) return Stub('error');

        return ListView.builder(
          itemCount: lists.length,
          itemBuilder: (context, index) => ListItem(
            name: lists[index].name,
            onTap: () => context.goNamed(
              sequenceName,
              extra: lists[index],
            ),
          ),
        );
      }),
    );
  }
}
