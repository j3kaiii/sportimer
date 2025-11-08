import 'package:flutter/material.dart';

/// Элемент списка созданных сиквенсов.
///
/// Каждый сиквенс представляет собой набор таймеров,
/// настройки цвета фона и звука.
class ListItem extends StatelessWidget {
  final String name;
  final Color? color;
  final VoidCallback? onTap;

  const ListItem({
    super.key,
    required this.name,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card.outlined(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.alarm_on_rounded,
              size: 60,
            ),
            Text(name),
          ],
        ),
      ),
    );
  }
}
