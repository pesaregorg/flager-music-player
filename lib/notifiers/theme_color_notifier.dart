import 'package:flutter/material.dart';
import 'package:flager_player/utilities/storage_manager.dart';

class ThemeColorProvider with ChangeNotifier{

  ThemeColorProvider() {
    _init();
  }

  MaterialColor themeColor = Colors.primaries[7];

  void _init() async{
    int? themeColorIndex = await StorageManager.readData("themeColor");
    themeColorIndex != null ? themeColor = Colors.primaries[themeColorIndex] : themeColor = Colors.primaries[7];

  }


  void changeThemeColor(int index){
    try{
      themeColor = Colors.primaries[index];
      StorageManager.saveData("themeColor", index);
      notifyListeners();
    }catch(e){
      debugPrint("not set theme color");
    }
  }

  MaterialColor get getThemeColor => themeColor;

}