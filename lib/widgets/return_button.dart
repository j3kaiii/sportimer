import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sportimer/utils/context_extension.dart';

class ReturnButton extends StatelessWidget {
  const ReturnButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.secondaryBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
      child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back, size: 18),
                color: theme.textSecondary,
                onPressed: () => context.pop(),
              ),
    );
  }
}