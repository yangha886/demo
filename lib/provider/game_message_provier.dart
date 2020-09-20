import 'package:flutter/material.dart';

class GameMessageProvier with ChangeNotifier{
  List messageList = List();
  newMessageArrive(String  msg) async{
    if(msg == null){
      messageList.clear();
      return;
    } 
    messageList.add(msg);
    notifyListeners();
  }
}