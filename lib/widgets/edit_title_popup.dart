import 'package:flutter/material.dart';
import 'package:sportimer/utils/context_extension.dart';

class EditTitlePopup extends StatefulWidget {
  final String title;
  const EditTitlePopup({super.key, required this.title});

  @override
  State<EditTitlePopup> createState() => _EditTitlePopupState();
}

class _EditTitlePopupState extends State<EditTitlePopup> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.title);
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
            if (text != null && text.isNotEmpty && text != widget.title) {
              Navigator.of(context).pop(text);
            }
          },
          child: Text(loc.btnSave),
        )
      ],
    );
  }
}
