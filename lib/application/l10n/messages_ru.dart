// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.
// @dart=2.12
// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String? MessageIfAbsent(
    String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'ru';

  String? lookupMessage(
      String? message_str,
      String? locale,
      String? name,
      List<Object>? args,
      String? meaning,
      {MessageIfAbsent? ifAbsent}) {
    String? failedLookup(
        String? message_str, List<Object>? args) {
      // If there's no message_str, then we are an internal lookup, e.g. an
      // embedded plural, and shouldn't fail.
      if (message_str == null) return null;
      throw UnsupportedError(
          "No translation found for message '$name',\n"
          "  original text '$message_str'");
    }
    return super.lookupMessage(message_str, locale, name, args, meaning,
        ifAbsent: ifAbsent ?? failedLookup);
  }

  static m0(index) => "Набор ${index}";

  static m1(current, total) => "Таймер ${current} из ${total}";

  @override
  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(_) => {
      'applicationName': MessageLookupByLibrary.simpleMessage('Спортаймер'),
    'btnAdd': MessageLookupByLibrary.simpleMessage('Добавить'),
    'btnCancel': MessageLookupByLibrary.simpleMessage('Отменить'),
    'btnOk': MessageLookupByLibrary.simpleMessage('OK'),
    'btnPause': MessageLookupByLibrary.simpleMessage('Пауза'),
    'btnReset': MessageLookupByLibrary.simpleMessage('Сбросить'),
    'btnResume': MessageLookupByLibrary.simpleMessage('Продолжить'),
    'btnSave': MessageLookupByLibrary.simpleMessage('Сохранить'),
    'btnStart': MessageLookupByLibrary.simpleMessage('Старт'),
    'changeTitle': MessageLookupByLibrary.simpleMessage('Изменить название'),
    'completedMsg': MessageLookupByLibrary.simpleMessage('Завершено!'),
    'orderedName': m0,
    'setTime': MessageLookupByLibrary.simpleMessage('Установить'),
    'setTimerTitle': MessageLookupByLibrary.simpleMessage('Установка таймера'),
    'timerByOrder': m1,
    'timerListTitle': MessageLookupByLibrary.simpleMessage('Мои таймеры')
  };
}
