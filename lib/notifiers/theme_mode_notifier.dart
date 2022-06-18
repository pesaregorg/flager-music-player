import 'package:flutter/material.dart';
import 'package:flager_player/utilities/storage_manager.dart';

class ThemeModeProvider with ChangeNotifier{

  ThemeModeProvider() {
    _init();
  }

  ThemeMode themeMode = ThemeMode.system;

  void _init() async{
    int? themeModeIndex = await StorageManager.readData("themeMode");
    themeModeIndex != null ? themeMode = ThemeMode.values[themeModeIndex] : themeMode = ThemeMode.system;
    notifyListeners();
  }


  void toggleThemeMode(){
    if(themeMode == ThemeMode.light){
      themeMode = ThemeMode.dark;
    }else if(themeMode == ThemeMode.dark){
      themeMode = ThemeMode.system;
    }else if(themeMode == ThemeMode.system){
      themeMode = ThemeMode.light;
    }

    StorageManager.saveData("themeMode", themeMode.index);
    notifyListeners();
  }


  ThemeMode get getThemeMode => themeMode;



}