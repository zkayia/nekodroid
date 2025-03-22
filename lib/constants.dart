import 'package:nekodroid/core/extensions/text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double kDefaultElevation = 4;

const double kPadding = 8;
const double kBorderRad = 10;
const BorderRadius kBorderRadCirc = BorderRadius.all(Radius.circular(kBorderRad));
const RoundedRectangleBorder kRoundedRecShape = RoundedRectangleBorder(borderRadius: kBorderRadCirc);
const double kLargeIconSize = 48;

const Duration kDefaultAnimDuration = Duration(milliseconds: 300);
const Curve kDefaultAnimCurve = Curves.easeInOutQuad;

const kAppLocale = Locale("fr", "FR");
const List<String> kWeekDays = [
  "Lundi",
  "Mardi",
  "Mercredi",
  "Jeudi",
  "Vendredi",
  "Samedi",
  "Dimanche",
];
const List<String> kMonths = [
  "Janvier",
  "Février",
  "Mars",
  "Avril",
  "Mai",
  "Juin",
  "Juillet",
  "Août",
  "Septembre",
  "Octobre",
  "Novembre",
  "Décembre",
];

final Uri kAppRepoUrl = Uri.https("github.com", "/zkayia/nekodroid");
final Uri kAppIssuesUrl = Uri.https("github.com", "/zkayia/nekodroid/issues");
final Uri kAppChangelogUrl = Uri.https("github.com", "/zkayia/nekodroid/blob/master/CHANGELOG.md");
final Uri kAppLicenseUrl = Uri.https("github.com", "/zkayia/nekodroid/blob/master/LICENSE");

const Color kNativePlayerControlsColor = Color(0xffffffff);

// const Color kPrimaryColor = Color(0xff64d092);
const Color kPrimaryColor = Color(0xff38C3FF);
const Color kOnPrimaryColor = Color(0xff000000);

final ThemeData kLightTheme = _buildTheme(
  brightness: Brightness.light,
  primary: kPrimaryColor,
  onPrimary: kOnPrimaryColor,
  background: const Color(0xffffffff),
  surface: const Color(0xfff5f5f5),
  text: const Color(0xff000000),
  dimmerText: const Color(0xff737373),
  error: const Color(0xffba1a1a),
  onError: const Color(0xffffffff),
  errorContainer: const Color(0xffffdad6),
  onErrorContainer: const Color(0xff000000),
);
final ThemeData kDarkTheme = _buildTheme(
  brightness: Brightness.dark,
  primary: kPrimaryColor,
  onPrimary: kOnPrimaryColor,
  background: const Color(0xff101010),
  surface: const Color(0xff1b1c1d),
  text: const Color(0xffffffff),
  dimmerText: const Color(0xff8c8c8c),
  error: const Color(0xffffb4ab),
  onError: const Color(0xff000000),
  errorContainer: const Color(0xff93000a),
  onErrorContainer: const Color(0xffffffff),
);

ThemeData _buildTheme({
  required Brightness brightness,
  required Color primary,
  required Color onPrimary,
  required Color background,
  required Color surface,
  required Color text,
  required Color dimmerText,
  required Color error,
  required Color onError,
  required Color errorContainer,
  required Color onErrorContainer,
}) {
  final theme = ThemeData(brightness: brightness);
  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: primary,
    onPrimary: onPrimary,
    secondary: Color.lerp(primary, surface, 0.7)!,
    onSecondary: text,
    surface: surface,
    onSurface: text,
    surfaceTint: Colors.transparent,
    outline: text,
    outlineVariant: dimmerText,
    error: error,
    onError: onError,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
  );
  final textTheme = theme.typography.geometryThemeFor(ScriptCategory.englishLike).merge(
        TextTheme(
          displayLarge: theme.textTheme.displayLarge?.copyWith(color: text), // 57
          displayMedium: theme.textTheme.displayMedium?.copyWith(color: text), // 45
          displaySmall: theme.textTheme.displaySmall?.copyWith(color: text), // 36
          headlineLarge: theme.textTheme.headlineLarge?.copyWith(color: text), // 32
          headlineMedium: theme.textTheme.headlineMedium?.copyWith(color: text), // 28
          headlineSmall: theme.textTheme.headlineSmall?.copyWith(color: text), // 24
          titleLarge: theme.textTheme.titleLarge?.copyWith(color: text), // 22
          titleMedium: theme.textTheme.titleMedium?.copyWith(color: text), // 16
          titleSmall: theme.textTheme.titleSmall?.copyWith(color: text), // 14
          bodyLarge: theme.textTheme.bodyLarge?.copyWith(color: text), // 16
          bodyMedium: theme.textTheme.bodyMedium?.copyWith(color: text), // 14
          bodySmall: theme.textTheme.bodySmall?.copyWith(color: text), // 12
          labelLarge: theme.textTheme.labelLarge?.copyWith(color: dimmerText), // 14
          labelMedium: theme.textTheme.labelMedium?.copyWith(color: dimmerText), // 12
          labelSmall: theme.textTheme.labelSmall?.copyWith(color: dimmerText), // 11
        ),
      );
  final iconTheme = theme.iconTheme.copyWith(
    color: text,
    weight: 700,
  );
  return theme.copyWith(
    brightness: brightness,
    scaffoldBackgroundColor: background,
    iconTheme: iconTheme,
    textTheme: textTheme,
    colorScheme: colorScheme,
    appBarTheme: theme.appBarTheme.copyWith(
      titleTextStyle: textTheme.titleLarge.bold(),
      iconTheme: iconTheme,
      backgroundColor: background,
    ),
    bottomSheetTheme: theme.bottomSheetTheme.copyWith(
      backgroundColor: background,
      elevation: kDefaultElevation,
      modalElevation: kDefaultElevation,
      showDragHandle: true,
    ),
    cardTheme: theme.cardTheme.copyWith(
      shape: kRoundedRecShape,
    ),
    chipTheme: theme.chipTheme.copyWith(
      shape: kRoundedRecShape,
    ),
    dialogTheme: theme.dialogTheme.copyWith(
      titleTextStyle: textTheme.titleLarge.bold(),
      contentTextStyle: textTheme.bodyLarge,
    ),
    dividerTheme: theme.dividerTheme.copyWith(
      color: colorScheme.surface,
      indent: kPadding * 2,
      endIndent: kPadding * 2,
      thickness: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: theme.elevatedButtonTheme.style?.copyWith(
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled) ? dimmerText : text,
        ),
        shape: const WidgetStatePropertyAll(kRoundedRecShape),
        textStyle: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled) ? textTheme.labelLarge : textTheme.titleSmall.bold(),
        ),
      ),
    ),
    listTileTheme: theme.listTileTheme.copyWith(
      shape: kRoundedRecShape,
      titleTextStyle: textTheme.titleMedium,
      subtitleTextStyle: textTheme.labelLarge,
      iconColor: iconTheme.color,
      horizontalTitleGap: kPadding,
    ),
    menuButtonTheme: MenuButtonThemeData(
      style: theme.menuButtonTheme.style?.copyWith(
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled) ? dimmerText : text,
        ),
      ),
    ),
    navigationBarTheme: theme.navigationBarTheme.copyWith(
      backgroundColor: surface,
      labelTextStyle: WidgetStatePropertyAll(textTheme.titleSmall),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => iconTheme.copyWith(fill: states.contains(WidgetState.selected) ? 1 : 0),
      ),
    ),
    navigationRailTheme: theme.navigationRailTheme.copyWith(
      unselectedIconTheme: iconTheme,
      selectedIconTheme: iconTheme.copyWith(fill: 1),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        defaultTargetPlatform: const CupertinoPageTransitionsBuilder(),
      },
    ),
    progressIndicatorTheme: theme.progressIndicatorTheme.copyWith(
      linearTrackColor: Colors.transparent,
      circularTrackColor: Colors.transparent,
    ),
    radioTheme: theme.radioTheme.copyWith(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? primary : iconTheme.color,
      ),
    ),
    scrollbarTheme: theme.scrollbarTheme.copyWith(
      radius: const Radius.circular(kBorderRad),
      interactive: true,
    ),
    tabBarTheme: theme.tabBarTheme.copyWith(
      dividerHeight: 0,
      indicator: UnderlineTabIndicator(
        borderRadius: kBorderRadCirc,
        borderSide: BorderSide(
          width: 3,
          color: primary,
        ),
      ),
    ),
  );
}
