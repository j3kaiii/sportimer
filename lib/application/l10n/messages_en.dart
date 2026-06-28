// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

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

  static m0(count) => "${count} intervals";

  static m1(index) => "Sequence ${index}";

  static m2(current, total) => "Timer ${current} of ${total}";

  @override
  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(_) => {
      '_difficultyHard': MessageLookupByLibrary.simpleMessage('Hard'),
    '_difficultyLight': MessageLookupByLibrary.simpleMessage('Light'),
    '_difficultyMedium': MessageLookupByLibrary.simpleMessage('Medium'),
    'addTimer': MessageLookupByLibrary.simpleMessage('Add timer'),
    'applicationName': MessageLookupByLibrary.simpleMessage('Sportimer'),
    'btnAdd': MessageLookupByLibrary.simpleMessage('Add'),
    'btnCancel': MessageLookupByLibrary.simpleMessage('Cancel'),
    'btnOk': MessageLookupByLibrary.simpleMessage('OK'),
    'btnPause': MessageLookupByLibrary.simpleMessage('Pause'),
    'btnReset': MessageLookupByLibrary.simpleMessage('Reset'),
    'btnResume': MessageLookupByLibrary.simpleMessage('Continue'),
    'btnSave': MessageLookupByLibrary.simpleMessage('Save'),
    'btnStart': MessageLookupByLibrary.simpleMessage('Start'),
    'changeTitle': MessageLookupByLibrary.simpleMessage('Change name'),
    'completedMsg': MessageLookupByLibrary.simpleMessage('Completed!'),
    'cyclicBadge': MessageLookupByLibrary.simpleMessage('Cyclic'),
    'difficultyTitle': MessageLookupByLibrary.simpleMessage('Difficulty'),
    'intervalsCountLabel': m0,
    'isRestTitle': MessageLookupByLibrary.simpleMessage('Relax'),
    'isTrainingTitle': MessageLookupByLibrary.simpleMessage('Workout'),
    'listIsEmpty': MessageLookupByLibrary.simpleMessage('List is empty'),
    'loadingTagline': MessageLookupByLibrary.simpleMessage('Create your timer'),
    'minutesLabel': MessageLookupByLibrary.simpleMessage('Min'),
    'newTimerTitle': MessageLookupByLibrary.simpleMessage('New timer'),
    'nextUpTimer': MessageLookupByLibrary.simpleMessage('Next: '),
    'orderedName': m1,
    'restToggleHint': MessageLookupByLibrary.simpleMessage('Switch to rest interval'),
    'secondsLabel': MessageLookupByLibrary.simpleMessage('Sec'),
    'setTime': MessageLookupByLibrary.simpleMessage('Set'),
    'setTimerTitle': MessageLookupByLibrary.simpleMessage('Set timer'),
    'singlePassBadge': MessageLookupByLibrary.simpleMessage('Single pass'),
    'timerByOrder': m2,
    'timerListTitle': MessageLookupByLibrary.simpleMessage('Timers'),
    'timerRestBadge': MessageLookupByLibrary.simpleMessage('REST'),
    'timerTrainingBadge': MessageLookupByLibrary.simpleMessage('WORKOUT')
  };
}
