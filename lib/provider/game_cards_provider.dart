import 'package:flutter/material.dart';

class GameCardsProvider with ChangeNotifier{
  Map gameList = Map();
  bool noNick = false;
  newBoardArrive(Map msg) async{
    if(msg == null){
      gameList.clear();
      return;
    } 
    gameList =  msg;
    notifyListeners();
  }
  changeNoNick(bool val) async{
    if(val == null){
      noNick = false;
      return;
    } 
    noNick = val;
    notifyListeners();
  }
}