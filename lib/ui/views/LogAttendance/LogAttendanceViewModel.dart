import 'package:mosque_attendance_app/app/locator.dart';
import 'package:mosque_attendance_app/models/Prayer.dart';
import 'package:mosque_attendance_app/services/DatabaseService.dart';
import 'package:mosque_attendance_app/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LogAttendanceViewModel extends BaseViewModel {
  final DatabaseService _databaseService = locator<DatabaseService>();
  bool isLoading = false;
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();


  logAttendanceManually(String phonenumber, Prayer prayer) async {
    isLoading = true;
    notifyListeners();

    User user = await _databaseService.getUserfromPhoneNumber(phonenumber);

    if (user == null) {
      _dialogService.showDialog(
          title: 'Invalid phone number',
          description: 'The phone number entered is invalid, please re-enter');
      isLoading = false;
      notifyListeners();
      return;
    }
    try {
      Prayer tempprayer =
          await _databaseService.logUserAttendance(user, prayer.documentID);
      if (tempprayer != null) {
        _navigationService.back();
        _dialogService.showDialog(
            title: "Success!", description: 'Attendance succesfully recorded.');
      } else {
        _navigationService.back();
        _dialogService.showDialog(
            title: 'Failure',
            description:
                'Unable to register attendance, it is likely that the congregation is full.');
      }
    } catch (e) {
      _dialogService.showDialog(title: 'Error', description: e.message + 'Please retry!');
    }

  isLoading = false;
    notifyListeners();
  }

}
