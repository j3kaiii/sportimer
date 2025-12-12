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
  final TextStyle defaultTextStyle;
  final TextStyle titleTextStyle;
  final TextStyle buttonTextStyle;
  final ButtonStyle buttonStyle;
  SportimerThemeData({
    this.coloredBackground,
    this.activeItemColor,
    this.primaryBgColor,
    this.secondaryBgColor,
  })  : buttonStyle = ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.amberAccent),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
          shadowColor: WidgetStateProperty.all(Colors.black26),
          side: WidgetStateProperty.all(
              BorderSide(width: 2.0, color: Colors.black87)),
          padding: WidgetStateProperty.all(
              EdgeInsets.symmetric(horizontal: 60, vertical: 12)),
        ),
        defaultTextStyle = TextStyle(fontSize: 20),
        titleTextStyle = TextStyle(fontSize: 28),
        buttonTextStyle = TextStyle(
          fontSize: 22,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        );

  static SportimerThemeData of(BuildContext context) => CustomThemes.safeOf(
        context,
        mainDefault: SportimerThemeData(),
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
