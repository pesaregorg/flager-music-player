import 'package:flager_player/notifiers/locale_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flager_player/notifiers/theme_color_notifier.dart';
import 'package:flager_player/notifiers/theme_mode_notifier.dart';
import 'package:flager_player/screens/components/icon_theme_mode.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(AppLocalizations.of(context)!.public_settings),
          ),
          ListTile(
            tileColor: Theme.of(context).primaryColor.withAlpha(30),
            onTap: () => _openModalSheetChangeLanguage(context),
            title: Text(AppLocalizations.of(context)!.chose_language),
            trailing: Text(
                Provider.of<LocaleNotifier>(context).getLocales.firstWhere(
                    (element) => element["code"] ==  Provider.of<LocaleNotifier>(context).getLocale.languageCode)["title"]
            ),
          ),
          //SizedBox(height: 4.0,),
          ListTile(
            tileColor: Theme.of(context).primaryColor.withAlpha(30),
            onTap: () => context.read<ThemeModeProvider>().toggleThemeMode(),
            title: Text(AppLocalizations.of(context)!.dark_mode),
            trailing: const IconThemeMode(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(AppLocalizations.of(context)!.chose_theme),
          ),
          Container(
            color: Theme.of(context).primaryColor.withAlpha(30),
            child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 5,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: List.generate(Colors.primaries.length, (index) {
                  return InkWell(
                    onTap: () => context.read<ThemeColorProvider>().changeThemeColor(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.primaries[index],
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Center(
                        child: Provider.of<ThemeColorProvider>(context).getThemeColor == Colors.primaries[index] ?
                        const Icon(Icons.done_rounded, color: Colors.white,) : const SizedBox.shrink(),
                      ),
                    ),
                  );
                })),
          )
        ],
      ),
    );
  }




  _openModalSheetChangeLanguage(BuildContext context) async{

    showModalBottomSheet(

        backgroundColor: Colors.transparent,
        context: context,
        builder: (context){
          return Container(
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListView.builder(
              itemCount: Provider.of<LocaleNotifier>(context).getLocales.length,
              itemBuilder: (context, index){
                final localeMap = Provider.of<LocaleNotifier>(context).getLocales[index];
                return ListTile(
                  title: Text(localeMap["title"]),
                  onTap: (){
                    context.read<LocaleNotifier>().changeLocale(localeMap["code"]);
                    Navigator.of(context).pop();
                  },
                  tileColor: Theme.of(context).primaryColor.withAlpha(30),
                  leading: localeMap["code"] == Provider.of<LocaleNotifier>(context).getLocale.languageCode ?
                  Icon(Icons.done_rounded) : SizedBox.shrink(),
                );
              },
            ),
          );
        });
  }



}
