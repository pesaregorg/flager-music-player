import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flager_player/screens/home_screen.dart';
import 'package:flager_player/screens/settings_acreen.dart';
import 'package:flager_player/screens/splash_screen.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page|Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashScreen, initial: true),
    AutoRoute(page: HomeScreen),
    AutoRoute(page: SettingsScreen),
  ],
)
// extend the generated private router
class AppRouter extends _$AppRouter{}