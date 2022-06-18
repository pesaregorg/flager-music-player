
import 'package:flutter/material.dart';

class ThemeHelper {

  static InputDecorationTheme inputDecorationTheme(ThemeData themeData){
    var primaryColor = themeData.primaryColor;
    var dividerColor = themeData.dividerColor;
    var errorColor = themeData.errorColor;
    var disabledColor = themeData.disabledColor;

    var width = 0.5;
    return InputDecorationTheme(
      hintStyle: TextStyle(fontSize: 14),
      isDense: true,

      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: width, color: errorColor)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.7, color: errorColor)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: width, color: primaryColor)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: width, color: dividerColor)),
      border: OutlineInputBorder(
          borderSide: BorderSide(width: width, color: dividerColor)),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: width, color: disabledColor)),
    );
  }
}