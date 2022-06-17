
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nekodroid/helpers/nav_labels_mode.dart';
import 'package:nekodroid/models/app_settings.dart';


const kFallbackLocale = Locale("en");

const kDefaultSettings = AppSettings(
	locale: null,
	themeMode: ThemeMode.system,
	useAmoled: false,
	defaultPage: 0,
	carouselItemCount: 5,
	secrecyEnabled: false,
	blurThumbs: true,
	blurThumbsShowSwitch: true,
	blurThumbsSigma: 12,
	navLabelsMode: NavLabelsMode.all,
	lazyLoadItemCount: 5,
);

// in ms
const int kWebviewPopDelay = 3 * 1000;
// in ms
const int kSearchDbMaxLifetime = 12 * 60 * 60 * 1000;

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
const double kAnimeCarouselBaseHeight = 200;
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
const Color kEpisodePlayButtonColor = Color(0xffffffff);
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
		dividerTheme: const DividerThemeData().copyWith(
			thickness: 1,
		),
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
		radioTheme: const RadioThemeData().copyWith(
			fillColor: MaterialStateColor.resolveWith(
				(states) => states.contains(MaterialState.selected)
					? accent
					: polar,
			),
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
		textButtonTheme: TextButtonThemeData(
			style: const ButtonStyle().copyWith(
				shape: MaterialStateProperty.all(
					RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(kBorderRadMain),
					),
				),
				tapTargetSize: MaterialTapTargetSize.shrinkWrap,
				backgroundColor: MaterialStateProperty.all(prim),
				overlayColor: MaterialStateProperty.all(baseTheme.splashColor),
			),
		),
		textTheme: const TextTheme().copyWith(
			displayMedium: const TextStyle().copyWith(
				overflow: TextOverflow.fade,
				color: polar,
				fontSize: 30,
				fontFamily: "Roboto",
				fontWeight: FontWeight.w700,
			),
			titleLarge: const TextStyle().copyWith(
				overflow: TextOverflow.fade,
				color: polar,
				fontSize: 16,
				fontFamily: "Roboto",
				fontWeight: FontWeight.w700,
			),
			titleMedium: const TextStyle().copyWith(
				overflow: TextOverflow.fade,
				color: polar,
				fontSize: 16,
				fontFamily: "Roboto",
				fontWeight: FontWeight.w400,
			),
			bodyLarge: const TextStyle().copyWith(
				overflow: TextOverflow.fade,
				color: polar,
				fontSize: 14,
				fontFamily: "Roboto",
				fontWeight: FontWeight.w400,
			),
			bodyMedium: const TextStyle().copyWith(
				overflow: TextOverflow.fade,
				color: polarAlt,
				fontSize: 14,
				fontFamily: "Roboto",
				fontWeight: FontWeight.w400,
			),
			bodySmall: const TextStyle().copyWith(
				overflow: TextOverflow.fade,
				color: polarAlt,
				fontSize: 12,
				fontFamily: "Roboto",
				fontWeight: FontWeight.w400,
			),
		),
	);
}
