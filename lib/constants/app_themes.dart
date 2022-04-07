import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  static const Color dodgerBlue = Color.fromRGBO(29, 161, 242, 1);
  static const Color whiteLilac = Color.fromRGBO(248, 250, 252, 1);
  static const Color blackPearl = Color.fromRGBO(30, 31, 43, 1);
  static const Color brinkPink = Color.fromRGBO(255, 97, 136, 1);
  static const Color juneBud = Color.fromRGBO(186, 215, 97, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color nevada = Color.fromRGBO(105, 109, 119, 1);
  static const Color ebonyClay = Color.fromRGBO(40, 42, 58, 1);
  static const Color black = Color.fromRGBO(0, 0, 0, 1);

  static const Color colorNotes = Color(0xFFBBDEFB);
  static const Color colorSchedules = Color(0xFF86C232);
  static const Color colorEvidences = Color(0xFFFFE400);
  static const Color colorCases = Color(0xFFFF652F);
  static const Color colorClients = Color(0xFF14A76C);

  //main color
  static const Color _darkPrimaryColor = black;

  //Background Colors
  static const Color _lightBackgroundColor = whiteLilac;
  static const Color _darkBackgroundAppBarColor = _darkPrimaryColor;
  static const Color _lightBackgroundSecondaryColor = white;
  static const Color _lightBackgroundAlertColor = blackPearl;
  static const Color _lightBackgroundActionTextColor = white;
  //Text Colors
  static const Color _lightTextColor = Colors.black;

  //Border Color
  static const Color _lightBorderColor = nevada;

  //form input colors
  static const Color _lightBorderActiveColor = _darkPrimaryColor;
  static const Color _lightBorderErrorColor = Colors.red;

  //text theme for light theme
  static final TextTheme _lightTextTheme = TextTheme(
    headline1: TextStyle(fontSize: 20.0, color: _lightTextColor),
    bodyText1: TextStyle(fontSize: 16.0, color: _lightTextColor),
    bodyText2: TextStyle(fontSize: 14.0, color: Colors.grey),
    button: TextStyle(fontSize: 15.0, color: _lightTextColor, fontWeight: FontWeight.w600),
    headline6: TextStyle(fontSize: 16.0, color: _lightTextColor),
    subtitle1: TextStyle(fontSize: 16.0, color: _lightTextColor),
    caption: TextStyle(fontSize: 12.0, color: _darkBackgroundAppBarColor),
  );

  //text theme for light theme
  static final TextTheme _appBarTextTheme = TextTheme(
    headline1: TextStyle(fontSize: 20.0, color: Colors.white),
    bodyText1: TextStyle(fontSize: 16.0, color: Colors.white),
    bodyText2: TextStyle(fontSize: 14.0, color: Colors.white),
    button: TextStyle(fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.w600),
    headline6: TextStyle(fontSize: 16.0, color: Colors.white),
    subtitle1: TextStyle(fontSize: 16.0, color: Colors.white),
    caption: TextStyle(fontSize: 12.0, color: Colors.white),
  );

  //the light theme
  static final ThemeData lightTheme = ThemeData(
    // brightness: Brightness.light,
    scaffoldBackgroundColor: _lightBackgroundSecondaryColor,
    primaryColor: _darkPrimaryColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: _lightBackgroundSecondaryColor,
      backgroundColor: _darkPrimaryColor,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: _darkBackgroundAppBarColor,
      iconTheme: IconThemeData(color: Colors.white),
      textTheme: _appBarTextTheme,
      brightness: Brightness.dark,
    ),
    colorScheme: ColorScheme.light(
      primary: _darkPrimaryColor,
      primaryVariant: _lightBackgroundColor,
      // secondary: _lightSecondaryColor,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _lightBackgroundAlertColor,
      actionTextColor: _lightBackgroundActionTextColor,
    ),
    iconTheme: IconThemeData(color: Colors.white),
    popupMenuTheme: PopupMenuThemeData(color: _darkBackgroundAppBarColor),
    textTheme: _lightTextTheme,
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      buttonColor: _darkPrimaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    // unselectedWidgetColor: _lightPrimaryColor,
    inputDecorationTheme: InputDecorationTheme(
      //prefixStyle: TextStyle(color: _lightIconColor),
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0),
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          )),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _lightBorderColor, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _lightBorderActiveColor),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _lightBorderErrorColor),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _lightBorderErrorColor),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      fillColor: _lightBackgroundSecondaryColor,
      //focusColor: _lightBorderActiveColor,
    ),
  );
}
