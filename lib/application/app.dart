import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_theme/flutter_custom_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sportimer/application/app_routes.dart';
import 'package:sportimer/application/consts.dart';
import 'package:sportimer/application/localizations.dart';
import 'package:sportimer/application/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sportimer/blocs/screens/list_screen_bloc/list_screen_bloc.dart';
import 'package:sportimer/models/timer_item/timer_item.dart';
import 'package:sportimer/models/timer_sequence/sequence.dart';
import 'package:sportimer/providers/hive_box_provider.dart';

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
        child: _buildGlobalBlocs(context, _buildApp(context)));
  }

  Widget _buildGlobalBlocs(BuildContext context, Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final boxProvider = HiveBoxProvider.of(context);
            return ListScreenBloc(
                boxProvider.sequenceBox, boxProvider.timersBox)
              ..add(const ListScreenShownEvent());
          },
        ),
      ],
      child: child,
    );
  }

  Widget _buildApp(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: SpotimerTheme.theme,
        darkTheme: SpotimerTheme.theme,
        routerConfig: appRoutes,
        localizationsDelegates: _localizationsDelegates,
      supportedLocales: _supportedLocales,
    );
  }
}

void runWithHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TimerItemAdapter());
  Hive.registerAdapter(SequenceAdapter());
  final sequenceBox = await Hive.openBox<Sequence>(sequenceBoxName);
  final timerBox = await Hive.openBox<TimerItem>(timersBoxName);
  runApp(
    HiveBoxProvider(
      sequenceBox: sequenceBox,
      timersBox: timerBox,
      child: const SportimerApp(),
    ),
  );
}
