import 'package:flutter/material.dart';
import 'package:flutter_custom_theme/flutter_custom_theme.dart';

class SpotimerTheme {
  static final _data = SportimerThemeData();

  static final theme = _data.theme();

  static final main = CustomThemeDataSet(data: _data, dataDark: _data);

  SpotimerTheme._();
}

class SportimerThemeData extends CustomThemeData {
  static const kBgDark = Color(0xFF0F172A);
  static const kBgCard = Color(0xFF1E293B);
  static const kBgSurface = Color(0xFF334155);
  static const kAccentWorkout = Color(0xFFEF4444);
  static const kAccentRest = Color(0xFF10B981);
  static const kAccentWorkoutSoft = Color(0x26EF4444);
  static const kAccentRestSoft = Color(0x2610B981);
  static const kTextPrimary = Color(0xFFF1F5F9);
  static const kTextSecondary = Color(0xFF94A3B8);
  static const kTextMuted = Color(0xFF64748B);
  static const kBorderColor = Color(0xFF475569);

  static const workoutGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFF97316)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const mixedGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [kAccentWorkout, kAccentRest],
  );

  final Color primaryBgColor;
  final Color secondaryBgColor;
  final Color activeItemColor;
  final Color coloredBackground;
  final Color accentRest;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color borderColor;
  final Color accentWorkoutSoft;
  final Color accentRestSoft;
  final Color cardBorderColor;
  final Color cardBadgeCyclicColor;
  final Color cardBadgeSingleColor;
  final Color cardBadgeCyclicBg;
  final Color cardBadgeSingleBg;

  final TextStyle defaultTextStyle;
  final TextStyle titleTextStyle;
  final TextStyle buttonTextStyle;
  final TextStyle loadingTitleStyle;
  final TextStyle taglineStyle;
  final TextStyle cardTitleStyle;
  final TextStyle cardMetaStyle;
  final TextStyle cardBadgeStyle;
  final TextStyle timerTypeStyle;
  final TextStyle timerDurationStyle;
  final TextStyle timerDifficultyStyle;
  final TextStyle popupTitleStyle;
  final TextStyle popupTimeSeparatorStyle;
  final TextStyle popupTimeValueStyle;
  final TextStyle popupTimeLabelStyle;
  final TextStyle popupToggleTitleStyle;
  final TextStyle popupToggleHintStyle;
  final TextStyle popupSectionTitleStyle;
  final TextStyle popupChipTextStyle;
  final TextStyle popupSaveTextStyle;
  final ButtonStyle buttonStyle;
  final TextStyle runningSeqNameStyle;
  final TextStyle runningTimerInfoStyle;
  final TextStyle runningCountdownStyle;
  final TextStyle runningTypeLabelStyle;
  final TextStyle nextUpStyle;
  final TextStyle nextUpBadgeStyle;

  SportimerThemeData({
    this.primaryBgColor = kBgDark,
    this.secondaryBgColor = kBgCard,
    this.activeItemColor = kAccentWorkout,
    this.coloredBackground = kBgSurface,
    this.accentRest = kAccentRest,
    this.textPrimary = kTextPrimary,
    this.textSecondary = kTextSecondary,
    this.textMuted = kTextMuted,
    this.borderColor = kBorderColor,
    this.accentWorkoutSoft = kAccentWorkoutSoft,
    this.accentRestSoft = kAccentRestSoft,
    this.cardBorderColor = const Color(0x0FFFFFFF),
    this.cardBadgeCyclicColor = const Color(0xFF60A5FA),
    this.cardBadgeSingleColor = const Color(0xFFC084FC),
    this.cardBadgeCyclicBg = const Color(0x2660A5FA),
    this.cardBadgeSingleBg = const Color(0x26C084FC),
  })  : defaultTextStyle = TextStyle(
          fontSize: 16,
          color: kTextSecondary,
        ),
        titleTextStyle = TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: kTextPrimary,
        ),
        buttonTextStyle = TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
        loadingTitleStyle = TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: kTextPrimary,
        ),
        taglineStyle = TextStyle(
          fontSize: 16,
          color: kTextMuted,
        ),
        cardTitleStyle = TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: kTextPrimary,
        ),
        cardMetaStyle = TextStyle(
          fontSize: 14,
          color: kTextMuted,
        ),
        cardBadgeStyle = TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        timerTypeStyle = TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        timerDurationStyle = TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        timerDifficultyStyle = TextStyle(
          fontSize: 11,
          color: kTextMuted,
        ),
        popupTitleStyle = TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: kTextPrimary,
        ),
        popupTimeSeparatorStyle = TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: kTextMuted,
        ),
        popupTimeValueStyle = TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          fontFeatures: [FontFeature.tabularFigures()],
          color: kTextPrimary,
        ),
        popupTimeLabelStyle = TextStyle(
          fontSize: 11,
          color: kTextMuted,
          letterSpacing: 0.5,
        ),
        popupToggleTitleStyle = TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: kTextPrimary,
        ),
        popupToggleHintStyle = TextStyle(
          fontSize: 12,
          color: kTextMuted,
        ),
        popupSectionTitleStyle = TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: kTextSecondary,
        ),
        popupChipTextStyle = TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        popupSaveTextStyle = TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        runningSeqNameStyle = TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: kTextSecondary,
        ),
        runningTimerInfoStyle = TextStyle(
          fontSize: 13,
          color: kTextMuted,
        ),
        runningCountdownStyle = TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w700,
          fontFeatures: [FontFeature.tabularFigures()],
          letterSpacing: -2,
          color: kTextPrimary,
        ),
        runningTypeLabelStyle = TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
          color: kAccentWorkout,
        ),
        nextUpStyle = TextStyle(
          fontSize: 12,
          color: kTextMuted,
        ),
        nextUpBadgeStyle = TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: kAccentRest,
        ),
        buttonStyle = ButtonStyle(
          backgroundColor: WidgetStateProperty.all(kAccentWorkout),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          shadowColor: WidgetStateProperty.all(
            kAccentWorkout.withValues(alpha: 0.35),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          textStyle: WidgetStateProperty.all(
            TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        );

  static SportimerThemeData of(BuildContext context) => CustomThemes.safeOf(
        context,
        mainDefault: SportimerThemeData(),
      );
}

extension _PlannerThemeDataExtension on SportimerThemeData {
  ThemeData theme() => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: primaryBgColor,
        appBarTheme: AppBarTheme(
          backgroundColor: secondaryBgColor,
          foregroundColor: textPrimary,
          centerTitle: true,
        ),
        cardColor: secondaryBgColor,
        colorScheme: ColorScheme.dark(
          primary: activeItemColor,
          secondary: accentRest,
          surface: secondaryBgColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: textPrimary,
        ),
        dividerColor: borderColor,
      );
}
