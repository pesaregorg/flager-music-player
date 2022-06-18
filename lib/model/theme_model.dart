

import 'package:flutter/material.dart';
import 'package:flager_player/helpers/theme_helper.dart';

class ThemeModel{


  ThemeData themeData({Brightness? brightness, MaterialColor? color, String? fontFamily}){

    var themeColor = color ?? Colors.blue;
    ThemeData themeData = ThemeData(
      useMaterial3: true,
      primaryColor: themeColor,
      brightness: brightness ?? Brightness.light,
      fontFamily: fontFamily,
      primarySwatch: themeColor,
    );

    themeData = themeData.copyWith(
      appBarTheme: themeData.appBarTheme.copyWith(elevation: 0),
      splashColor: themeColor.withAlpha(50),
      hintColor: themeData.hintColor.withAlpha(90),
      errorColor: Colors.red,
      inputDecorationTheme: ThemeHelper.inputDecorationTheme(themeData),
      switchTheme: themeData.switchTheme.copyWith(
        trackColor: MaterialStateColor.resolveWith((states){
          if (states.contains(MaterialState.selected)) {
            return themeColor.shade400;
          }
          return Colors.grey.withOpacity(0.48);
        }),
        thumbColor: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return themeColor;
          }
          return Colors.grey;
        }),
      ),
      tabBarTheme: themeData.tabBarTheme.copyWith(
        labelStyle: themeData.tabBarTheme.labelStyle?.copyWith(
          letterSpacing: 0,
        ),
        labelColor: themeColor,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: themeColor,
              width: 2.0,
            )
          )
        )
      )
    );

    return themeData;
  }


}