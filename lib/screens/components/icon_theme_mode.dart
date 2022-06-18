import 'package:flutter/material.dart';
import 'package:flager_player/notifiers/theme_mode_notifier.dart';
import 'package:provider/provider.dart';

class IconThemeMode extends StatelessWidget {
  const IconThemeMode({Key? key}) : super(key: key);


  IconData _renderIconThemeMode(ThemeMode themeMode){
    switch (themeMode){
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      default:
        return Icons.brightness_medium_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(_renderIconThemeMode(Provider.of<ThemeModeProvider>(context).getThemeMode));
  }
}
