import 'package:auto_route/auto_route.dart';
import 'package:flager_player/notifiers/locale_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flager_player/model/theme_model.dart';
import 'package:flager_player/notifiers/theme_color_notifier.dart';
import 'package:flager_player/notifiers/theme_mode_notifier.dart';
import 'package:flager_player/services/service_locator.dart';
import 'package:flager_player/utilities/app_providers.dart';
import 'package:flager_player/utilities/app_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flager_player/utilities/page_manager.dart';
import 'package:provider/provider.dart';



void main() async{
  Provider.debugCheckInvalidValueType = null;
  await setupServiceLocator();
  runApp(
      AppProviders(
        child: MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();
  final _themeModel = ThemeModel();

  @override
  void initState() {
    super.initState();
    getIt<PageManager>().init();
  }

  @override
  void dispose() {
    getIt<PageManager>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      title: "Flager Player",
      theme: _themeModel.themeData(
          color: Provider.of<ThemeColorProvider>(context).getThemeColor,
          brightness: Brightness.light,
          fontFamily: Provider.of<LocaleNotifier>(context).getFontFamily
      ),
      darkTheme: _themeModel.themeData(
          color: Provider.of<ThemeColorProvider>(context).getThemeColor,
          brightness: Brightness.dark,
          fontFamily: Provider.of<LocaleNotifier>(context).getFontFamily
      ),
      themeMode: Provider.of<ThemeModeProvider>(context).getThemeMode,
      routerDelegate: AutoRouterDelegate(
        _appRouter,
        // Provide an AutoRouteObserver instance
        navigatorObservers: () => [AutoRouteObserver()],
      ),
      routeInformationParser: _appRouter.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
      locale: Provider.of<LocaleNotifier>(context).getLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}



