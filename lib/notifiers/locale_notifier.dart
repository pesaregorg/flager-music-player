import 'package:flager_player/utilities/storage_manager.dart';
import 'package:flutter/material.dart';

class LocaleNotifier with ChangeNotifier{
  Locale? _locale;
  String? _fontFamily;
  final List<Map> _locales = [
    {
      "code": "fa",
      "title": "فارسی",
      "locale": const Locale("fa", "IR")
    },
    {
      "code": "en",
      "title": "English",
      "locale": const Locale("en", "US")
    }
  ];


  LocaleNotifier(){
    _init();
  }


  void _init() async{
    String? localeCode = await StorageManager.readData("localeCode");

    switch(localeCode){
      case "fa":
        _fontFamily = "Vazir";
        _locale = _locales.firstWhere((element) => localeCode == element["code"])["locale"];
        break;
      case "en":
        _fontFamily = "Poppins";
        _locale = _locales.firstWhere((element) => localeCode == element["code"])["locale"];
        break;
      default:
        _fontFamily = "Vazir";
        _locale = _locales.first["locale"];
        break;
    }
    notifyListeners();
  }


  void changeLocale(String localeCode) {
    if(localeCode == "fa" || localeCode == "en"){
      StorageManager.saveData("localeCode", localeCode);
      _init();
    }
  }

  Locale get getLocale => _locale ?? _locales.first["locale"];
  List<Map> get getLocales => _locales;
  String get getFontFamily => _fontFamily ?? "Vazir";
}