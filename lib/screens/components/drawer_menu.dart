import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flager_player/notifiers/theme_mode_notifier.dart';
import 'package:flager_player/screens/components/icon_theme_mode.dart';
import 'package:flager_player/utilities/app_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(AppLocalizations.of(context)!.app_name),
              accountEmail: Text(""),
              otherAccountsPictures: [
                IconButton(
                    onPressed: () => context.read<ThemeModeProvider>().toggleThemeMode(),
                    icon: const IconThemeMode()
                )
              ],
              currentAccountPicture: const CircleAvatar(),
              /*decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,

              ),*/
            ),

            ListTile(
              title: Text(AppLocalizations.of(context)!.settings, style: TextStyle(fontWeight: FontWeight.w900),),
              leading: Icon(Icons.settings),
              onTap: (){
                context.router.pop();
                context.router.push(const SettingsRoute());
              },
            )
          ],
        )
    );
  }
}
