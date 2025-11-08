import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: Color(0xFFE0712D),
  // Primary color for the app
  scaffoldBackgroundColor: Color(0xFFFFFAF7),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFE0712D), // Primary color for the app
    secondary: Color(0xFFFF9500), // Secondary color for the app
    surface: Color(0xFFFFF0E6), // Background color for the app
    error: Colors.red, // Error color
    onPrimary: Colors.white, // Text color on primary color
    onSecondary: Colors.black, // Text color on secondary color
    onSurface: Colors.black, // Text color on background color
    onError: Colors.white, // Text color on error color
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFFFFAF7), // Background color for AppBar
    foregroundColor: Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardColor: Color(0xFFFFF0E6), // Color for cards
  iconTheme: IconThemeData(
    color: Color(0xFFFF3E01), // Color for icons
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFE0712D)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFFFF0E6),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
  ),
  textTheme: TextTheme(
    bodySmall: TextStyle(
      color: Color(0xFF000000), // Text color for small text
      fontSize: 12.0, // Font size for small text
      fontWeight: FontWeight.w400,
      fontFamily: 'assets/fonts/Poppins-Regular.ttf',
    ),
    headlineSmall: TextStyle(
      color: Colors.black,
      fontSize: 16.0, // Font size for small headlines
      fontWeight: FontWeight.w500,
      fontFamily: 'assets/fonts/Poppins-Medium.ttf',
    ),
    headlineMedium: TextStyle(
      color: Colors.black,
      fontSize: 20.0, // Font size for medium headlines
      fontWeight: FontWeight.w600,
      fontFamily: 'assets/fonts/Poppins-SemiBold.ttf',
    ),
    labelMedium: TextStyle(
      fontFamily: 'assets/fonts/Poppins-Medium.ttf',
      color: Colors.white, // Text color for medium labels
      fontSize: 18.0, // Font size for medium labels
      fontWeight: FontWeight.w500,
    ),
  ),
);
