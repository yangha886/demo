import 'package:flutter/material.dart';

class IndexPageDataProvider with ChangeNotifier{
  Map mineDataMap = {};

  getMineData(mineData) {
    mineDataMap = mineData;
    notifyListeners();
  }
}