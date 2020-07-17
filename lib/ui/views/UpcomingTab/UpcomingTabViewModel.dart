import 'package:flutter/material.dart';
import 'package:mosque_attendance_app/app/locator.dart';
import 'package:mosque_attendance_app/services/DatabaseService.dart';
import 'package:stacked/stacked.dart';

class UpcomingTabViewModel extends BaseViewModel {
  DatabaseService _databaseService = locator<DatabaseService>();
  DateTime now = DateTime.now();
  String mosqueName = "Masjid-al-Furqaan";
  Stream stream;

  getUpcomingPrayersStream() {
    stream = _databaseService.upcomingPrayersStream(now, mosqueName);
    return stream;
  }

  Future getPrayers() async {
    return _databaseService.getUpcomingPrayers(now, mosqueName);
  }
}
