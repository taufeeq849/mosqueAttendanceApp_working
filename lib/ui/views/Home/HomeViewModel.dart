import 'package:flutter/material.dart';
import 'package:mosque_attendance_app/ui/views/PreviousTab/PreviousTabView.dart';
import 'package:mosque_attendance_app/ui/views/ScannerTab/ScannerTabView.dart';
import 'package:mosque_attendance_app/ui/views/UpcomingTab/UpcomingTabView.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  String _title = 'Home View';

  String get title => _title;
  int tabIndex = 0;

  Map<int, bool> originalDic;

  List<Widget> listScreens;
  List<int> listScreensIndex;


  void updateTabIndex(index){
    tabIndex = index;
    notifyListeners();

  }

}
