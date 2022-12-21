
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nekodroid/extensions/iterable.dart';
import 'package:nekodroid/models/app_settings.dart';


const kFallbackLocale = Locale("en");

const kDefaultSettings = AppSettings();

// all of the below are in ms
const int kHeadlessWebviewMaxLifetime = 20 * 1000;

const Duration kDefaultAnimDuration = Duration(milliseconds: 300);
const Curve kDefaultAnimCurve = Curves.easeInOutQuad;
const ScrollPhysics kDefaultScrollPhysics = ClampingScrollPhysics();

const double kDefaultElevation = 6;

const double kPaddingMain = 16;
const double kPaddingSecond = 8;
const double kPaddingCarousels = kPaddingMain + kPaddingSecond;
const double kBorderRadMain = 10;
const double kBorderRadSecond = 5;
const double kPaddingGenresGrid = 5;

const double kLargeIconSize = 48;
const double kDotIndicatorSize = 5;
const double kTabbarIndicatorSize = 2;
const double kFabSize = 56;
const double kAnimeCarouselMinHeight = 200;
const double kTopBarHeight = 46;
const double kBottomBarHeight = 56;
const double kEpisodeThumbnailMaxWidth = 200;
const double kAnimePageGroupMaxHeight = 200;
const double kAnimeListTileMaxHeight = 100;
const EdgeInsetsGeometry kAnimeCardBadgeTextPadding = EdgeInsets.symmetric(
  horizontal: 4,
  vertical: 2,
);

const Color _kAccentColor = Color(0xff1cb9f4);
const Color _kOnAccentColor = Color(0xff000000);
const Color kNativePlayerControlsColor = Color(0xffffffff);
const Color kOnImageColor = Color(0xffffffff);
const Color kAnimeCardBadgeColor = Color(0xfff9f9f9);
const Color kAnimeCardBadgeShadow = Color.fromARGB(160, 0, 0, 0);
const Color kShadowThumbWithIcon = Color.fromARGB(100, 0, 0, 0);
const List<Color> kShadowColors = [Colors.black, Colors.transparent];
const List<double> kShadowStops = [0, 0.1];


final Uri kAppRepoUrl = Uri.https("github.com", "/zkayia/nekodroid");

final ThemeData darkTheme = _buildTheme(
  brightness: Brightness.dark,
  accent: _kAccentColor,
  onAccent: _kOnAccentColor,
  prim: const Color(0xff262626),
  primAlt: const Color(0xff171717),
  polar: const Color(0xfff9f9f9),
  polarAlt: const Color(0xffb9b9b9),
);

final ThemeData lightTheme = _buildTheme(
  brightness: Brightness.light,
  accent: _kAccentColor,
  onAccent: _kOnAccentColor,
  prim: const Color(0xfffafafa),
  primAlt: const Color(0xffefefef),
  // prim: const Color(0xfffafafa),
  // primAlt: const Color(0xfffafafa),
  polar: const Color(0xff2c2c2c),
  polarAlt: const Color(0xff505050),
);

final ThemeData amoledTheme = _buildTheme(
  brightness: Brightness.dark,
  accent: _kAccentColor,
  onAccent: _kOnAccentColor,
  prim: const Color(0xff171717),
  primAlt: const Color(0xff000000),
  polar: const Color(0xfff9f9f9),
  polarAlt: const Color(0xffb9b9b9),
);

ThemeData _buildTheme({
  required Brightness brightness,
  required Color accent,
  required Color onAccent,
  required Color prim,
  required Color primAlt,
  required Color polar,
  required Color polarAlt,
}) {
  final isDark = brightness == Brightness.dark;
  final baseTheme = isDark ? ThemeData.dark() : ThemeData.light();
  final buttonStyle = const ButtonStyle().copyWith(
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    minimumSize: MaterialStateProperty.all(const Size.square(kMinInteractiveDimension)),
    overlayColor: MaterialStateProperty.all(baseTheme.splashColor),
    elevation: MaterialStateProperty.resolveWith(
      (states) => states.contains(MaterialState.disabled)
        ? 0
        : kDefaultElevation,
    ),
    backgroundColor: MaterialStateProperty.resolveWith(
      (states) => {
        MaterialState.disabled: primAlt,
        MaterialState.selected: accent,
      }.entries.firstWhereOrNull((e) => states.contains(e.key))?.value ?? prim,
    ),
    foregroundColor: MaterialStateProperty.resolveWith(
      (states) => {
        MaterialState.disabled: baseTheme.disabledColor,
        MaterialState.selected: onAccent,
      }.entries.firstWhereOrNull((e) => states.contains(e.key))?.value ?? polar,
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadMain),
      ),
    ),
    padding: MaterialStateProperty.all(
      const EdgeInsets.all(kPaddingSecond),
    ),
  );
  final textTheme = const TextTheme().copyWith(
    displayMedium: const TextStyle().copyWith(
      overflow: TextOverflow.fade,
      color: polar,
      fontSize: 30,
      fontWeight: FontWeight.w700,
    ),
    displaySmall: const TextStyle().copyWith(
      overflow: TextOverflow.fade,
      color: polar,
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: const TextStyle().copyWith(
      overflow: TextOverflow.fade,
      color: polar,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: const TextStyle().copyWith(
      overflow: TextOverflow.fade,
      color: polar,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyLarge: const TextStyle().copyWith(
      overflow: TextOverflow.fade,
      color: polar,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: const TextStyle().copyWith(
      overflow: TextOverflow.fade,
      color: polarAlt,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: const TextStyle().copyWith(
      overflow: TextOverflow.fade,
      color: polarAlt,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  );
  return baseTheme.copyWith(
    primaryColor: prim,
    scaffoldBackgroundColor: primAlt,
    indicatorColor: accent,
    canvasColor: prim,
    colorScheme: (
      isDark ? const ColorScheme.dark() : const ColorScheme.light()
    ).copyWith(
      background: primAlt,
      surface: prim,
      primary: accent,
      onPrimary: onAccent,
      secondary: accent,
      onSecondary: onAccent,
      tertiary: accent,
      onTertiary: onAccent,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primAlt,
      foregroundColor: polar,
      elevation: kDefaultElevation,
      toolbarHeight: kTopBarHeight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadMain),
      ),
      systemOverlayStyle: brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark,
    ),
    bottomAppBarTheme: const BottomAppBarTheme().copyWith(
      color: Colors.transparent,
      elevation: kDefaultElevation,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: prim,
      selectedItemColor: accent,
      unselectedItemColor: polarAlt,
    ),
    bottomSheetTheme: const BottomSheetThemeData().copyWith(
      elevation: kDefaultElevation,
      modalElevation: kDefaultElevation,
      backgroundColor: primAlt,
      modalBackgroundColor: primAlt,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kBorderRadMain),
          topRight: Radius.circular(kBorderRadMain),
        ),
      ),
    ),
    buttonTheme: const ButtonThemeData().copyWith(
      alignedDropdown: true,
    ),
    cardTheme: const CardTheme().copyWith(
      color: prim,
      elevation: kDefaultElevation,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadMain),
      ),
    ),
    checkboxTheme: const CheckboxThemeData().copyWith(
      checkColor: MaterialStateProperty.all(onAccent),
      fillColor: MaterialStateColor.resolveWith(
        (states) => states.contains(MaterialState.selected)
          ? accent
          : polarAlt,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadSecond),
      ),
    ),
    chipTheme: const ChipThemeData().copyWith(
      backgroundColor: prim,
      brightness: brightness,
      padding: EdgeInsets.zero,
      selectedColor: accent,
      labelPadding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: -2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadSecond),
      ),
    ),
    dialogTheme: const DialogTheme().copyWith(
      backgroundColor: primAlt,
      elevation: kDefaultElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadMain),
      ),
      titleTextStyle: textTheme.displaySmall,
    ),
    dividerTheme: const DividerThemeData().copyWith(
      thickness: 1,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
    floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
      backgroundColor: prim,
      foregroundColor: polar,
      elevation: kDefaultElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadMain),
      ),
    ),
    iconTheme: const IconThemeData().copyWith(
      color: polar,
    ),
    inputDecorationTheme: const InputDecorationTheme().copyWith(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: kPaddingSecond),
    ),
    listTileTheme: const ListTileThemeData().copyWith(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadMain),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      horizontalTitleGap: 4,
      selectedColor: accent,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
    radioTheme: const RadioThemeData().copyWith(
      fillColor: MaterialStateColor.resolveWith(
        (states) => states.contains(MaterialState.selected)
          ? accent
          : polar,
      ),
    ),
    scrollbarTheme: const ScrollbarThemeData().copyWith(
      thumbColor: MaterialStateProperty.all(Colors.red),
      thumbVisibility: MaterialStateProperty.all(true),
    ),
    sliderTheme: const SliderThemeData().copyWith(
      thumbColor: accent,
      trackHeight: 8,
      activeTrackColor: accent,
      inactiveTrackColor: prim,
      tickMarkShape: SliderTickMarkShape.noTickMark,
      overlayShape: SliderComponentShape.noOverlay,
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorTextStyle: const TextStyle().copyWith(color: onAccent),
    ),
    switchTheme: const SwitchThemeData().copyWith(
      thumbColor: MaterialStateColor.resolveWith(
        (states) => states.contains(MaterialState.selected)
          ? accent
          : polarAlt,
      ),
      trackColor: MaterialStateColor.resolveWith(
        (states) => states.contains(MaterialState.selected)
          ? accent
          : prim,
      ),
    ),
    tabBarTheme: const TabBarTheme().copyWith(
      labelColor: polar,
      unselectedLabelColor: polarAlt,
      indicator: UnderlineTabIndicator(
        insets: const EdgeInsets.symmetric(horizontal: kPaddingMain),
        borderSide: BorderSide(
          color: accent,
          width: kTabbarIndicatorSize,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(style: buttonStyle),
    textTheme: textTheme,
  );
}
