import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mosque_attendance_app/app/locator.dart';
import 'package:mosque_attendance_app/models/Prayer.dart';
import 'package:mosque_attendance_app/services/DatabaseService.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class GenerateQRViewModel extends BaseViewModel {
  List<String> prayers = ['Fajr', 'Zuhr', 'Asr', 'Maghrib', 'Esha', 'Jummah'];
  List<String> numberOfJammats = [
    'Jamaat 1',
    'Jamaat 2',
    'Jamaat 3',
    'Jamaat 4'
  ];
  String selectedprayer = 'Fajr';
  String selectedJamaat = 'Jamaat 1';
  TimeOfDay selectedTime;
  DialogService _dialogService = locator<DialogService>();
  DatabaseService _databaseService = locator<DatabaseService>();
  QrImage _QRImage;
  String qrData;

  get QRImage => _QRImage;
  bool isLoading = false;
  Prayer prayer;
  bool QRCodeGenerated = false;

  BuildContext buildContext;

  buildDropDownMenuItems() {
    return prayers
        .map((String prayer) => new DropdownMenuItem(
              value: prayer,
              child: new Text((prayer)),
            ))
        .toList();
  }

  onDropdownSelect(String dropdownSelectedprayer) {
    this.selectedprayer = dropdownSelectedprayer;
    notifyListeners();
  }

  updateSelectedTime(TimeOfDay timeOfDay) {
    if (timeOfDay != null) {
      selectedTime = timeOfDay;
    } else {
      _dialogService.showDialog(
          title: "Failure, time not selected!",
          description: "QR Code can not be generated without a time");
    }
    notifyListeners();
  }

  generateQRCode() async {
    isLoading = true;
    notifyListeners();

    if (selectedTime != null) {
      DateTime dateTime = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, selectedTime.hour, selectedTime.minute);
if (dateTime.isBefore(DateTime.now())) {
  _dialogService.showDialog(title: 'Invalid time selected!', description: "You have selected a time which is in the past, please select a time which is in the future.");
  isLoading = false;
  notifyListeners();
  return;

}
      prayer = new Prayer(
          mosque_name: 'Masjid-al-Furqaan',
          prayer_name: selectedprayer,
          date: dateTime);
      qrData = await _databaseService.generatePrayerDocument(prayer);
      if (qrData != null) {
        _QRImage = QrImage(data: qrData);
      } else {
        _dialogService.showDialog(
            title: "Failure generating code", description: "Try again later!");
      }
      QRCodeGenerated = true;
      isLoading = false;
      notifyListeners();
    } else {
      _dialogService.showDialog(
          title: "The relevant information was not selected",
          description: "Please fill in all the fields to generate the QR code.");
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> captureAndSharePng() async {
    final image = QrPainter(
      data: qrData,
      color: Colors.black,
      emptyColor: Colors.white,
      version: QrVersions.auto,
      gapless: false,
    );
    final a = await image.toImageData(300, format: ImageByteFormat.png);
    var byteData = a.buffer.asUint8List();

    await Share.file('QR Code for ${prayer.prayer_name}',
        '${prayer.prayer_name}.png', byteData, 'image/png',
        text: 'QR Code to log attendance for ${prayer.prayer_name} at ${prayer.date.toString()}');
  }
}
