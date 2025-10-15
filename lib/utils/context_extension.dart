import 'package:flutter/material.dart';
import 'package:sportimer/application/localizations.dart';
import 'package:sportimer/application/theme.dart';

extension ContextExtension on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
  SportimerThemeData get theme => SportimerThemeData.of(this);
}
