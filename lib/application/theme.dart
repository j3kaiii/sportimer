import 'package:flutter/material.dart';
import 'package:flutter_custom_theme/flutter_custom_theme.dart';

class SpotimerTheme {
  static final _data = SportimerThemeData(
    coloredBackground: const Color.fromARGB(255, 218, 243, 244),
    activeItemColor: Colors.green,
    primaryBgColor: Colors.white,
    secondaryBgColor: Colors.lightBlue,
  );

  static final theme = _data.theme();

  static final main = CustomThemeDataSet(data: _data, dataDark: _data);

  SpotimerTheme._();
}

class SportimerThemeData extends CustomThemeData {
  const SportimerThemeData({
    this.coloredBackground,
    this.activeItemColor,
    this.primaryBgColor,
    this.secondaryBgColor,
  });

  static SportimerThemeData of(BuildContext context) => CustomThemes.safeOf(
        context,
        mainDefault: const SportimerThemeData(),
      );

  // Цвет фона шторки
  final Color? coloredBackground;

  // Цвет активного элемента
  final Color? activeItemColor;

  // Основной цвет фона
  final Color? primaryBgColor;

  // Дополнительный цвет фона
  final Color? secondaryBgColor;
}

extension _PlannerThemeDataExtension on SportimerThemeData {
  ThemeData theme() => ThemeData();
}
