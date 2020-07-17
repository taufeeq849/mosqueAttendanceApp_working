
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mosque_attendance_app/services/DatabaseService.dart';
import 'package:mosque_attendance_app/services/FirebaseAuthService.dart';

import 'package:mosque_attendance_app/services/auth_service.dart';
import 'package:mosque_attendance_app/ui/views/AddUserData/AddUserDataView.dart';
import 'package:mosque_attendance_app/ui/views/Home/HomeView.dart';
import 'package:mosque_attendance_app/ui/views/Register/RegisterView.dart';


import 'app/locator.dart';
import 'ui/views/AddUserData/AddUserDataView.dart';
import 'ui/views/Home/HomeView.dart';
import 'ui/views/Home/HomeView.dart';
import 'ui/views/Register/RegisterView.dart';


class LandingPage extends StatelessWidget {
  final FirebaseAuthService _authService = locator<FirebaseAuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: _authService.onAuthStateChanged,
      builder: (_, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;

          if (user == null) {
            //should be registerview in production
            return RegisterView();
          } else {
            return StreamBuilder(
              stream: _databaseService.getUserDataStream(user.uid, user.phone_number),
              builder: (context, snapshot) {

                if (!snapshot.hasData || !snapshot.data.exists) {
                  return
                    //change this to addUserDataView(), default return will be home view for the purpose of emulator testing
                    AddUserDataView();
                } else {
                  return HomeView();
                }
              },
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );
  }
}
