import 'package:flager_player/notifiers/locale_notifier.dart';
import 'package:flager_player/notifiers/playlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flager_player/notifiers/theme_color_notifier.dart';
import 'package:flager_player/notifiers/theme_mode_notifier.dart';
import 'package:provider/provider.dart';


class AppProviders extends StatefulWidget {
  Widget child;
  AppProviders({required this.child, Key? key}) : super(key: key);

  @override
  State<AppProviders> createState() => _AppProvidersState();
}

class _AppProvidersState extends State<AppProviders> {




  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeModeProvider>(create: (_) => ThemeModeProvider()),
        ChangeNotifierProvider<ThemeColorProvider>(create: (_) => ThemeColorProvider()),
        ChangeNotifierProvider<PlaylistNotifier>(create: (_) => PlaylistNotifier()),
        ChangeNotifierProvider<LocaleNotifier>(create: (_) => LocaleNotifier()),
      ],
      child: widget.child,
    );
  }
}
