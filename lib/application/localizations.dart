import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multiple_localization/multiple_localization.dart';
import 'package:sportimer/application/l10n/messages_all_locales.dart';

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
      Intl.message('Рабочее название', name: 'applicationName');
  String get btnAdd => Intl.message('Добавить', name: 'btnAdd');
  String get btnCancel => Intl.message('Отменить', name: 'btnCancel');
  String get btnOk => Intl.message('OK', name: 'btnOk');
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
