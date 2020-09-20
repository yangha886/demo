import 'package:flutter/material.dart';

class GameOpenPokersProvider with ChangeNotifier{
  List pokes  = List();
  setOpenpokes(List ps) async{
    pokes = ps;
    notifyListeners();
  }

}