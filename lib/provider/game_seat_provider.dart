import 'package:flutter/material.dart';

class GameSeatProvider with ChangeNotifier{
  List seatList = List();
  setSeatData(List _seatList) async{
    seatList = _seatList;
    notifyListeners();
  }
}