import 'package:flutter/material.dart';

class GameDashboardThemeProvider with ChangeNotifier{
  int themeType  = 0;

  setThemeType(int type) async{
    themeType = type;
    notifyListeners();
  }

}