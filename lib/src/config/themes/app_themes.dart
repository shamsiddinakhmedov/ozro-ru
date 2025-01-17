part of 'themes.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  applyElevationOverlayColor: true,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
      TargetPlatform.windows: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
    },
  ),
  // splashFactory: Platform.isAndroid ? InkRipple.splashFactory : NoSplash.splashFactory,
  visualDensity: VisualDensity.standard,
  materialTapTargetSize: MaterialTapTargetSize.padded,
  highlightColor: colorLightScheme.primary.withOpacity(0.05),
  splashColor: colorLightScheme.primary.withOpacity(0.1),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero),
    ),
  ),
  dividerTheme: const DividerThemeData(
    thickness: 1.3,
    color: Color(0xFFF2F2F2),
  ),
);

final ThemeData lightTheme = appTheme.copyWith(
  extensions: <ThemeExtension<dynamic>>[
    ThemeTextStyles.light,
    ThemeColors.light,
  ],
  drawerTheme: DrawerThemeData(
    backgroundColor: colorLightScheme.surface,
    surfaceTintColor: colorLightScheme.surface,
    shape: const RoundedRectangleBorder(),
  ),
  primaryColor: colorLightScheme.primary,
  colorScheme: colorLightScheme,
  dialogBackgroundColor: colorLightScheme.surface,
  scaffoldBackgroundColor: const Color(0xFFF4F4F4),
  cardColor: Colors.white,
  canvasColor: Colors.white,
  dialogTheme: const DialogTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return colorLightScheme.primary.withOpacity(0.6);
          }else {
            return Colors.white;
          }
        },
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return colorLightScheme.primary.withOpacity(0.06);
          } else {
            return colorLightScheme.primary;
          }
        },
      ),
      textStyle: WidgetStatePropertyAll(ThemeTextStyles.light.buttonStyle),
      elevation: const WidgetStatePropertyAll(0),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      fixedSize: const WidgetStatePropertyAll(Size(double.infinity, 48)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => Colors.black,
      ),
      textStyle: WidgetStatePropertyAll(ThemeTextStyles.light.buttonStyle),
      elevation: const WidgetStatePropertyAll(0),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      fixedSize: const WidgetStatePropertyAll(Size(double.infinity, 48)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    alignLabelWithHint: true,
    hintStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Color(0xff9AA6AC),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorLightScheme.primary, width: 2),
      borderRadius: AppUtils.kBorderRadius12,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: AppUtils.kBorderRadius12,
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorLightScheme.error, width: 2),
      borderRadius: AppUtils.kBorderRadius12,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorLightScheme.error, width: 2),
      borderRadius: AppUtils.kBorderRadius12,
    ),
    border: const OutlineInputBorder(
      borderSide: BorderSide(width: 2),
      borderRadius: AppUtils.kBorderRadius12,
    ),
    disabledBorder: const OutlineInputBorder(
      borderRadius: AppUtils.kBorderRadius12,
      borderSide: BorderSide.none,
    ),
    // filled: true,
    isDense: true,
    // fillColor: Colors.white,
    floatingLabelBehavior: FloatingLabelBehavior.always,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    elevation: 20,
    showDragHandle: true,
    dragHandleSize: const Size(40, 4),
    dragHandleColor: Colors.black.withOpacity(0.1),
    modalElevation: 20,
    shadowColor: Colors.black.withOpacity(0.08),
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    selectedLabelStyle: const TextStyle(fontSize: 12),
    unselectedLabelStyle: const TextStyle(fontSize: 12),
    unselectedItemColor: const Color(0xffA0A9B6),
    selectedItemColor: colorLightScheme.primary,
    elevation: 2,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: Color(0xff111126),
    unselectedLabelColor: Color(0xff111126),
    dividerColor: Colors.transparent,
    overlayColor: WidgetStatePropertyAll(Colors.transparent),
    labelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    indicator: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 0,
    backgroundColor: Colors.white,
    height: kToolbarHeight,
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
      (states) => const IconThemeData(
        color: Colors.black,
      ),
    ),
    labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
      (states) => ThemeTextStyles.light.appBarTitle,
    ),
  ),
  appBarTheme: AppBarTheme(
    elevation: 4,
    centerTitle: true,
    shadowColor: Colors.black.withOpacity(0.06),
    scrolledUnderElevation: 1,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,

      /// ios
      statusBarBrightness: Brightness.light,

      /// android
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 17,
    ),
    toolbarTextStyle: ThemeTextStyles.light.appBarTitle,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 34,
    ),

    /// text field title style
    titleMedium: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 17,
    ),
    titleSmall: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 17,
    ),

    /// list tile title style
    bodyLarge: TextStyle(
      color: Colors.black,
      fontSize: 20,
      // fontWeight: FontWeight.w600,
    ),

    /// list tile subtitle style
    bodyMedium: TextStyle(
      color: Colors.black,
      // fontWeight: FontWeight.w600,
      fontSize: 17,
    ),
    bodySmall: TextStyle(
      color: Colors.black,
      // fontWeight: FontWeight.w600,
      fontSize: 15,
    ),
    displayLarge: TextStyle(
      color: Colors.black,
    ),
    displayMedium: TextStyle(
      color: Colors.black,
      // fontWeight: FontWeight.w600,
      fontSize: 17,
    ),
    displaySmall: TextStyle(
      color: Colors.black,
    ),
  ),
);

final ThemeData darkTheme = appTheme.copyWith(
  extensions: <ThemeExtension<dynamic>>[
    ThemeTextStyles.dark,
    ThemeColors.dark,
  ],
  drawerTheme: DrawerThemeData(
    backgroundColor: colorDarkScheme.surface,
    surfaceTintColor: colorDarkScheme.surface,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    elevation: 0,
    showDragHandle: true,
    dragHandleSize: const Size(40, 4),
    dragHandleColor: Colors.black.withOpacity(0.1),
    backgroundColor: colorDarkScheme.surface,
    surfaceTintColor: colorDarkScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
  ),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.white,
    labelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    indicator: BoxDecoration(
      color: Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      border: Border.all(color: Colors.blue, width: 2),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    elevation: 2,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    },
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    centerTitle: true,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // systemNavigationBarColor: ThemeColors.primary,

      /// android
      statusBarIconBrightness: Brightness.light,

      /// ios
      statusBarBrightness: Brightness.dark,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: ThemeTextStyles.dark.appBarTitle,
    // backgroundColor: ThemeColors.cardBackgroundDark,
  ),
  inputDecorationTheme: InputDecorationTheme(
    alignLabelWithHint: true,
    hintStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Color(0xff9AA6AC),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorDarkScheme.primary, width: 2),
      borderRadius: AppUtils.kBorderRadius12,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFFFFFFF), width: 2),
      borderRadius: AppUtils.kBorderRadius12,
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorDarkScheme.error, width: 2),
      borderRadius: AppUtils.kBorderRadius12,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colorDarkScheme.primary, width: 2),
      borderRadius: AppUtils.kBorderRadius12,
    ),
    border: const OutlineInputBorder(borderSide: BorderSide(width: 2), borderRadius: AppUtils.kBorderRadius12),
    disabledBorder: const OutlineInputBorder(
      borderRadius: AppUtils.kBorderRadius12,
      borderSide: BorderSide(color: Color(0xFFf5f5f5), width: 2),
    ),
    filled: true,
    isDense: true,
    fillColor: Colors.white,
    floatingLabelBehavior: FloatingLabelBehavior.always,
  ),
  textTheme: const TextTheme(
    bodySmall: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 17,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 17,
    ),
  ),
);
