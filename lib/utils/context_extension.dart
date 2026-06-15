import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sportimer/application/localizations.dart';
import 'package:sportimer/application/theme.dart';
import 'package:sportimer/models/timer_item/timer_item.dart';
import 'package:sportimer/models/timer_sequence/sequence.dart';
import 'package:sportimer/providers/hive_box_provider.dart';

extension ContextExtension on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
  SportimerThemeData get theme => SportimerThemeData.of(this);
  Box<Sequence> get sequenceBox => HiveBoxProvider.of(this).sequenceBox;
  Box<TimerItem> get timersBox => HiveBoxProvider.of(this).timersBox; 
}
