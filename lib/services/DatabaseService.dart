import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mosque_attendance_app/models/Prayer.dart';

import 'auth_service.dart';

class DatabaseService {
  DatabaseService();

  User _user;

  User get user => _user;
  String uid, phoneno;

  CollectionReference _usercollectionReference =
      Firestore.instance.collection("users");
  CollectionReference _attendanceCollectionRecord =
      Firestore.instance.collection('Masjid-al-Furqaan');

  Stream getUserDataStream(String uid, phoneno) {
    this.uid = uid;
    this.phoneno = phoneno;
    return _usercollectionReference.document(uid).snapshots();
  }

  Future addUserData(User user) async {
    await _usercollectionReference.document(uid).setData(user.toJson());
  }

  Future logUserAttendance(User user, String prayerDocID) async {
    var document = _attendanceCollectionRecord.document(prayerDocID);
    Map<String, dynamic> map = {
      'attendees': FieldValue.arrayUnion([user.uid])
    };
    document.updateData(map);
    //logging data under each individual mosque
    var fetchedDocument = await document.get();
    Prayer prayer = Prayer().fromJson(fetchedDocument.data, true);
    if (prayer.currentCapacity >= prayer.maxCapacity) {
      return null;
    }

    //logging data under user collection for easier querying later on
    await _usercollectionReference
        .document(uid)
        .collection('prayers_attended')
        .document(prayerDocID)
        .setData(prayer.toJson());

    return prayer;
  }

  Future getUserData(String uid) async {
    var document = await _usercollectionReference.document(uid).get();
    _user = User().fromJson(document.data);
    return _user;
  }

  Future generatePrayerDocument(Prayer prayer) async {
    bool prayerExists = false;
    String documentID;
    QuerySnapshot existingDoc = await _attendanceCollectionRecord
        .where('mosque_name', isEqualTo: prayer.mosque_name)
        .where('prayer_name', isEqualTo: prayer.prayer_name)
        .where('date', isEqualTo: prayer.date)
        .limit(1)
        .getDocuments();
    existingDoc.documents.forEach((element) {
      if (element.data != null) {
        prayerExists = true;
      }
    });

    if (prayerExists) {
      existingDoc.documents.forEach((element) {
        documentID = element.documentID;
        prayer.documentID = documentID;
      });
    } else {
      var document = _attendanceCollectionRecord.document();
      prayer.documentID = document.documentID;
      await document.setData(prayer.toJson());
      documentID = document.documentID;
    }

    return documentID;
  }

  Stream upcomingPrayersStream(DateTime now, String mosqueName) {
    DateTime tomorrow = DateTime(
      now.year,
      now.month,
      now.day + 1,
    );
    return _attendanceCollectionRecord
        .where('date', isGreaterThan: now)
        .where('date', isLessThanOrEqualTo: tomorrow)
        .orderBy('date')
        .snapshots();
  }

  Future getUpcomingPrayers(DateTime now, String mosqueName) async {
    DateTime tomorrow = DateTime(
      now.year,
      now.month,
      now.day + 1,
    );
    QuerySnapshot docs = await _attendanceCollectionRecord
        .where('date', isGreaterThan: now)
        .where('date', isLessThanOrEqualTo: tomorrow)
        .orderBy('date')
        .getDocuments();
    List<Prayer> prayers = [];
    docs.documents.forEach((element) {
      Prayer prayer = Prayer().fromJson(element.data, true);
      prayers.add(prayer);
    });

    return prayers;
  }

  Stream previousPrayersStream(User user, DateTime dateTime) {
    if (user != null) {
      return _attendanceCollectionRecord
          .where('attendees', arrayContains: user.uid)
          .snapshots();
    }
  }

  Future getPreviousPrayers(User user, DateTime dateTime) async {
    List<Prayer> prayers = [];
    DateTime twoWeeksAgo =
        DateTime(dateTime.year, dateTime.month, dateTime.day - 12);

    QuerySnapshot querySnapshot = await _attendanceCollectionRecord
        .where('attendees', arrayContains: user.uid)
        .where('date', isGreaterThanOrEqualTo: twoWeeksAgo)
      .orderBy('date', descending: true)
        .getDocuments();

    querySnapshot.documents.forEach((element) {
      Prayer prayer = Prayer().fromJson(element.data, true);
      prayers.add(prayer);
    });
    return prayers;
  }

  Future reportCOVIDCase(User user, List<Prayer> prayersAttended) async {
    Future.delayed(Duration(seconds: 1));
    for (Prayer prayer in prayersAttended) {
      _attendanceCollectionRecord.document(prayer.documentID).updateData({
        'infected_array': FieldValue.arrayUnion([user.uid])
      });
    }
  }

  Future getUserfromPhoneNumber(String phoneNumber) async {
    print('getting user from phone number');
    QuerySnapshot document = await _usercollectionReference
        .where('phone_number', isEqualTo: phoneNumber)
        .limit(1)
        .getDocuments();
    User user;
    document.documents.forEach((element) {

      user = User().fromJson(element.data);
    });
    return user;
  }
}
