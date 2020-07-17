import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mosque_attendance_app/app/locator.dart';
import 'package:mosque_attendance_app/models/Prayer.dart';
import 'package:mosque_attendance_app/services/DatabaseService.dart';
import 'package:mosque_attendance_app/services/FirebaseAuthService.dart';
import 'package:mosque_attendance_app/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ScannerTabViewModel extends BaseViewModel {
  String _title = 'Home View';
  String scantext;
  Prayer prayer;
  String QRCodeID;

  String get title => _title;
  DialogService _dialogService = locator<DialogService>();
  DatabaseService _databaseService = locator<DatabaseService>();
  FirebaseAuthService _authService = locator<FirebaseAuthService>();
  User user;
  bool isLoading = false;
  bool generate_pressed = false;

  Future scan() async {
    try {
      var scanresult = await BarcodeScanner.scan();
      scantext = scanresult.rawContent;
      if (scantext.length > 0) {
        QRCodeID = scantext;
        await logAttendanceinDB();
        if (prayer != null) {
          _dialogService.showDialog(
              title: "Success",
              description:
                  "Succesfully registered attendance for ${prayer.prayer_name} ${prayer.mosque_name}");
        } else {
          _dialogService.showDialog(
              title: "Max Capacity has been reached!",
              description:
                  'The maximum size of this congregation has exceeded. According to government regulations, you are not allowed to enter!');
        }
      } else {
        _dialogService.showDialog(
            title: "Failure", description: "Please re-scan");
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        _dialogService.showDialog(
            title: "QR Code Scan Failed",
            description:
                "The camera permission is denied, please enable the permission to proceed further");
      } else {
        _dialogService.showDialog(
            title: "QR Code Scan Failed", description: e.message);
      }
    } on FormatException {
      _dialogService.showDialog(
          title: "Error in scanning",
          description:
              "Back button was pressed before scan could be completed, please re-scan");
    } catch (e) {
      print(e.toString());
    }
  }

  bool updateOnPressed(bool isPressed) {
    generate_pressed = isPressed;
    notifyListeners();
  }

  Future logAttendanceinDB() async {
    Prayer tempPrayer =
        await _databaseService.logUserAttendance(user, QRCodeID);
    this.prayer = tempPrayer;
  }

  Future getCurrentUser() async {
    isLoading = true;
    notifyListeners();

    User firebase_user = await _authService.getFirebaseUser();
    User final_user = await _databaseService.getUserData(firebase_user.uid);
    this.user = final_user;
    isLoading = false;
    notifyListeners();
  }
}
