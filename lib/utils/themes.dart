import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class MyThemes {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
      primarySwatch: Colors.orange,
      fontFamily: GoogleFonts.aBeeZee().fontFamily,
      //scaffoldBackgroundColor: LinearGradient(colors: gradientColor),
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        color: Colors.orange,
        elevation: 10.0,
        shadowColor: Colors.orange,
        toolbarTextStyle: Theme.of(context).textTheme.bodyText2,
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ));

  static ThemeData darkTheme(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.lightBlue,
      );
  static Color backgroundColor = const Color(0xff9DD4DA);
  static List<Color> gradientColor = [grad1, grad2];
  static Color grad2 = const Color(0xff001D2A);
  static Color grad1 = const Color(0xff071D24);
  static Color textColor = const Color(0xff03525C);
}
