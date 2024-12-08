import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_track_app/core/theme/app_pallet.dart';

class AdaptiveThemeConfig {
  static border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: AppPallete.lightBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.lightBackgroundColor,
      elevation: 0,
    ),
    useMaterial3: true,
    brightness: Brightness.light,
    // chipTheme: ChipThemeData(
    //   color: const MaterialStatePropertyAll(AppPallete.lightBackgroundColor),
    //   backgroundColor: AppPallete.lightBackgroundColor,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(4),
    //   ),
    // ),
    textTheme: GoogleFonts.latoTextTheme(
      ThemeData.dark().textTheme,
    ).apply(
      bodyColor: AppPallete.darkBackgroundColor,
      displayColor: AppPallete.darkBackgroundColor,
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: border(AppPallete.lightborderColor),
      focusedBorder: border(AppPallete.primaryColor),
      errorBorder: border(AppPallete.errorColor),
      focusedErrorBorder: border(AppPallete.errorColor),
    ),
    cardTheme: CardTheme(
      color: AppPallete.lightBackgroundColor,
      shadowColor: AppPallete.greyColor.withOpacity(0.5),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(10),
    ),
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: AppPallete.darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.darkBackgroundColor,
      elevation: 0,
    ),
    useMaterial3: true,
    brightness: Brightness.dark,
    // chipTheme: ChipThemeData(
    //   color: const MaterialStatePropertyAll(AppPallete.darkBackgroundColor),
    //   backgroundColor: AppPallete.darkBackgroundColor,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(4),
    //   ),
    // ),
    textTheme: GoogleFonts.latoTextTheme(
      ThemeData.dark().textTheme,
    ).apply(
      bodyColor: AppPallete.lightBackgroundColor,
      displayColor: AppPallete.lightBackgroundColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: border(AppPallete.greyColor),
      focusedBorder: border(AppPallete.primaryDarkColor),
      errorBorder: border(AppPallete.errorColor),
      focusedErrorBorder: border(AppPallete.errorColor),
    ),
    cardTheme: CardTheme(
      color: AppPallete.cardDarkBackgroundColor,
      shadowColor: Colors.black.withOpacity(0.5),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(10),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 35, 35, 61),
      unselectedItemColor: Color.fromARGB(255, 95, 95, 119),
    ),
  );

  static const initialThemeMode = AdaptiveThemeMode.light;
}
