import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multiple_localization/multiple_localization.dart';
import 'package:sportimer/application/l10n/messages_all_locales.dart';
import 'package:sportimer/models/timer_item/timer_item.dart';

typedef DelegateBuilder<T> = FutureOr<T> Function(String locale);

class AppLocalizations {
  static const _locales = [Locale('ru'), Locale('en')];
  static const LocalizationsDelegate<AppLocalizations> delegate =
      DefLocalizationsDelegate<AppLocalizations>(
          AppLocalizations.new, _locales);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  final String locale;

  AppLocalizations(this.locale);

  String get applicationName =>
      Intl.message('Спортаймер', name: 'applicationName');
  String get btnAdd => Intl.message('Добавить', name: 'btnAdd');
  String get btnCancel => Intl.message('Отменить', name: 'btnCancel');
  String get btnOk => Intl.message('OK', name: 'btnOk');
  String get btnStart => Intl.message('Старт', name: 'btnStart');
  String get btnPause => Intl.message('Пауза', name: 'btnPause');
  String get btnResume => Intl.message('Продолжить', name: 'btnResume');
  String get btnReset => Intl.message('Сбросить', name: 'btnReset');
  String get btnSave => Intl.message('Сохранить', name: 'btnSave');
  String get timerListTitle =>
      Intl.message('Мои таймеры', name: 'timerListTitle');
  String get changeTitle =>
      Intl.message('Изменить название', name: 'changeTitle');
  String get setTimerTitle =>
      Intl.message('Установка таймера', name: 'setTimerTitle');
  String get setTime => Intl.message('Установить', name: 'setTime');
  String get listIsEmpty => Intl.message('Список пуст', name: 'listIsEmpty');

  String orderedName(int index) => Intl.message(
        'Набор $index',
        name: 'orderedName',
        args: [index],
      );

  String timerByOrder(int current, int total) => Intl.message(
        'Таймер $current из $total',
        name: 'timerByOrder',
        args: [current, total],
      );

  String get completedMsg => Intl.message('Завершено!', name: 'completedMsg');
  String get isRestTitle => Intl.message('Отдых', name: 'isRestTitle');
  String get isTrainingTitle =>
      Intl.message('Тренировка', name: 'isTrainingTitle');
  String get addTimer => Intl.message('Добавить таймер', name: 'addTimer');
  String get nextUpTimer => Intl.message('Далее: ', name: 'nextUpTimer');

  String get newTimerTitle =>
      Intl.message('Новый таймер', name: 'newTimerTitle');
  String get minutesLabel => Intl.message('Мин', name: 'minutesLabel');
  String get secondsLabel => Intl.message('Сек', name: 'secondsLabel');
  String get difficultyTitle =>
      Intl.message('Сложность', name: 'difficultyTitle');
  String get restToggleHint =>
      Intl.message('Переключить на интервал отдыха', name: 'restToggleHint');
  String get timerRestBadge => Intl.message('ОТДЫХ', name: 'timerRestBadge');
  String get timerTrainingBadge =>
      Intl.message('ТРЕНИРОВКА', name: 'timerTrainingBadge');
  String get cyclicBadge => Intl.message('Цикличный', name: 'cyclicBadge');
  String get singlePassBadge =>
      Intl.message('Однопроходный', name: 'singlePassBadge');
  String get loadingTagline =>
      Intl.message('Создай свой таймер', name: 'loadingTagline');
  String get btnDelete => Intl.message('Удалить', name: 'btnDelete');
  String get deleteTimerTitle =>
      Intl.message('Удалить текущий таймер', name: 'deleteTimerTitle');
  String get repeatsLabel =>
      Intl.message('Циклов:', name: 'repeatsLabel');
  String cycleLabel(int current, int total) => Intl.message(
        'Цикл $current из $total',
        name: 'cycleLabel',
        args: [current, total],
      );

  String intervalsCountLabel(int count) => Intl.message(
        '$count интервалов',
        name: 'intervalsCountLabel',
        args: [count],
      );

  String get _difficultyLight =>
      Intl.message('Легкая', name: '_difficultyLight');
  String get _difficultyMedium =>
      Intl.message('Средняя', name: '_difficultyMedium');
  String get _difficultyHard =>
      Intl.message('Сложная', name: '_difficultyHard');

  String difficultyLabel(Difficulty difficulty) => switch (difficulty) {
        Difficulty.light => _difficultyLight,
        Difficulty.medium => _difficultyMedium,
        Difficulty.hard => _difficultyHard,
      };

  String formatDuration(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class DefLocalizationsDelegate<T> extends LocalizationsDelegate<T> {
  final DelegateBuilder<T> builder;
  final List<Locale> locales;

  const DefLocalizationsDelegate(this.builder, this.locales);

  @override
  bool isSupported(Locale locale) =>
      locales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<T> load(Locale locale) {
    return MultipleLocalizations.load(initializeMessages, locale, builder,
        setDefaultLocale: true, fallbackLocale: 'en');
  }

  @override
  bool shouldReload(LocalizationsDelegate<T> old) => false;
}
