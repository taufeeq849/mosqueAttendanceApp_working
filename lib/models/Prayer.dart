import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mosque_attendance_app/services/auth_service.dart';

class Prayer {
  String mosque_name, prayer_name, documentID;
  DateTime date;
  int currentCapacity, maxCapacity, infectedCount;

  Prayer(
      {this.mosque_name,
      this.prayer_name,
      this.date,
      this.currentCapacity,
      this.maxCapacity,
      this.infectedCount,
      this.documentID});

  List<User> attendees = [];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> infected_array = new HashMap();
    Map<String, dynamic> attendees_map = new HashMap();
    return {
      'prayer_name': prayer_name,
      'mosque_name': mosque_name,
      'date': date,
      'attendees': attendees_map,
      'infected_array': infected_array,
      'documentID': documentID
    };
  }

  Prayer fromJson(Map<String, dynamic> map, bool checkCapacity) {
    Timestamp timestamp = map['date'];
    DateTime date = timestamp.toDate();
    if (checkCapacity) {
      return Prayer(
          mosque_name: map['mosque_name'],
          prayer_name: map['prayer_name'],
          date: date,
          currentCapacity: map['attendees'].length,
          maxCapacity: 50,
          infectedCount: map['infected_array'].length,
          documentID: map['documentID']);
    }

    return Prayer(
        mosque_name: map['mosque_name'],
        prayer_name: map['prayer_name'],
        date: date);
  }
}
