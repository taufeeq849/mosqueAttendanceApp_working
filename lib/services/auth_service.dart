import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

@immutable
class User {
  User({this.uid, this.phone_number});

  String _name, _ID_number;

  set name(String value) {
    _name = value;
  }

  String phone_number;
  var prayerDocIDs;

  String get name => _name;

  final String uid;

  set ID_number(value) {
    _ID_number = value;
  }

  get ID_number => _ID_number;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> prayerDocIDs = new HashMap();
    return {
      'name': name,

      'phone_number': phone_number,
      'uid': uid,
      'prayerDocIDs': prayerDocIDs
    };
  }

  User fromJson(Map json) {
    User user = new User(uid: json['uid'], phone_number: json['phone_number']);
    user.name = json['name'];

    user.prayerDocIDs = json['prayerDocIDs'];
    return user;
  }
}

abstract class AuthService {
  User getCurrentUserfromFirebaseUser(FirebaseUser user);

  Future getFirebaseUser();

  Future signInwithPhoneNumber(AuthCredential authCredential);

  Future signInwithOTP(smsCode, verificationCode);

  Stream<User> get onAuthStateChanged;

  Future signOut();

  void dispose();
}
