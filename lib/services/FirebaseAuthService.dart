import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mosque_attendance_app/services/auth_service.dart';

class FirebaseAuthService implements AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



  @override
  User getCurrentUserfromFirebaseUser(FirebaseUser user) {
    if (user == null){

      return null;
    }
    User abstract_user = User(uid: user.uid, phone_number: user.phoneNumber);
    return abstract_user;
  }

  @override
  Future signInwithOTP(smsCode, verificationCode) async {
    // TODO: implement signInwithOTP
    AuthCredential authCredential = PhoneAuthProvider.getCredential(verificationId: verificationCode, smsCode: smsCode);
    try {
      var authresult = await _firebaseAuth.signInWithCredential(authCredential);
      return getCurrentUserfromFirebaseUser(authresult.user) == null;
    } catch (e) {
      return e.message;
    }
  }

  @override
  Future signInwithPhoneNumber(AuthCredential authCredential) async {
    // TODO: implement signInwithPhoneNumber
    try {
      var user = await _firebaseAuth.signInWithCredential(authCredential);

      return user;
    } catch (e) {
      return e.message;
    }
  }

  @override
  Future<User> getFirebaseUser() async {
    // TODO: implement getFirebaseUser
    final FirebaseUser user = await _firebaseAuth.currentUser();
    User unique_user =  getCurrentUserfromFirebaseUser(user);
    return unique_user;


  }
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(getCurrentUserfromFirebaseUser);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future signOut() {
   _firebaseAuth.signOut();
  }
}
