import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sportimer/application/consts.dart';
import 'package:sportimer/utils/context_extension.dart';

/// Загрузочный экран.
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const image = 'assets/images/image.png';
    final theme = context.theme;
    return Material(
      color: theme.primaryBgColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: theme.secondaryBgColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset(image),
              ),
            ),
            ElevatedButton(
              onPressed: () => context.goNamed(root),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'loading',
                  style: TextStyle(fontSize: 26, color: theme.primaryBgColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
