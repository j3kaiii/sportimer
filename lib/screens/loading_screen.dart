import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sportimer/application/consts.dart';
import 'package:sportimer/utils/context_extension.dart';

/// Загрузочный экран.
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const image = 'assets/images/timer.png';
    final theme = context.theme;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
          context.goNamed(root);
        }
      });
    });
    return GestureDetector(
      onTap: () => context.goNamed(root),
      child: Material(
        color: theme.primaryBgColor,
        child: Center(
          child: Image.asset(image),
        ),
      ),
    );
  }
}
