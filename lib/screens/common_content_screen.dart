import 'package:flutter/material.dart';
import 'package:sportimer/utils/context_extension.dart';

class CommonContentScreen extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget child;
  final Widget? floatingButton;
  final FloatingActionButtonLocation floatingButtonLocation;

  const CommonContentScreen({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.floatingButton,
    this.floatingButtonLocation = FloatingActionButtonLocation.centerFloat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: context.theme.titleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: context.theme.secondaryBgColor,
        actions: actions,
      ),
      body: child,
      floatingActionButton: floatingButton,
      floatingActionButtonLocation: floatingButtonLocation,
    );
  }
}
