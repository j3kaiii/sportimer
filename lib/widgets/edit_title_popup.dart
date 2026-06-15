import 'package:flutter/material.dart';
import 'package:sportimer/utils/context_extension.dart';

class EditTitlePopup extends StatefulWidget {
  final List<String> existingTitles;
  final String prevTitle;
  const EditTitlePopup(
      {super.key, required this.existingTitles, required this.prevTitle});

  @override
  State<EditTitlePopup> createState() => _EditTitlePopupState();
}

class _EditTitlePopupState extends State<EditTitlePopup> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.prevTitle);
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(loc.changeTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          EditableText(
            controller: _controller ?? TextEditingController(),
            focusNode: FocusNode()..requestFocus(),
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.red,
              fontSize: 24,
            ),
            cursorColor: Colors.blueAccent,
            backgroundCursorColor: Colors.amberAccent,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(loc.btnCancel),
        ),
        TextButton(
          onPressed: () {
            final text = _controller?.text;
            if (_isTitleCorrect(text)) {
              Navigator.of(context).pop(text);
            }
          },
          child: Text(loc.btnSave),
        )
      ],
    );
  }

  bool _isTitleCorrect(String? title) {
    if (title == null) return false;
    if (widget.existingTitles.isEmpty) return true;
    final hasTitle = widget.existingTitles
        .any((t) => t.toLowerCase() == title.toLowerCase());
    return title != widget.prevTitle && !hasTitle;
  }
}
