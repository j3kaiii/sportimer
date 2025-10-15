import 'package:flutter/material.dart';
import 'package:flutter_custom_theme/flutter_custom_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sportimer/application/app_routes.dart';
import 'package:sportimer/application/localizations.dart';
import 'package:sportimer/application/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class SportimerApp extends StatelessWidget {
  static final List<LocalizationsDelegate<dynamic>> _localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const _supportedLocales = [
    Locale('en'),
    Locale('ru'),
  ];

  static final _themesData = [SpotimerTheme.main];

  const SportimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomThemes(
      data: _themesData,
      child: MaterialApp.router(
        theme: SpotimerTheme.theme,
        darkTheme: SpotimerTheme.theme,
        routerConfig: appRoutes,
        localizationsDelegates: _localizationsDelegates,
        supportedLocales: _supportedLocales,
      ),
    );
  }
}

void runWithHive() async {
  await Hive.initFlutter();
  // Hive.registerAdapter(ItemAdapter());
  // Hive.registerAdapter(ShoppingListAdapter());
  // await Hive.openBox<ShoppingList>(listsBoxName);
  runApp(const SportimerApp());
}
