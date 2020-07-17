

import 'package:mosque_attendance_app/app/locator.dart';
import 'package:mosque_attendance_app/models/Prayer.dart';
import 'package:mosque_attendance_app/services/DatabaseService.dart';
import 'package:mosque_attendance_app/services/FirebaseAuthService.dart';
import 'package:mosque_attendance_app/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PreviousTabViewModel extends BaseViewModel {
  String _title = 'previous View';

  String get title => _title;
  final DatabaseService _databaseService = locator<DatabaseService>();
  final FirebaseAuthService _authService = locator<FirebaseAuthService>();
  final DialogService _dialogService = locator<DialogService>();
  User user;
  List<Prayer> prayersAttended;
  bool isLoading = false;

  getCurrentUser() async {
    User firebaseUser = await _authService.getFirebaseUser();
    User abstractUser = await _databaseService.getUserData(firebaseUser.uid);
    this.user = abstractUser;
  }

  Future getPreviousPrayers() async {
    prayersAttended =
        await _databaseService.getPreviousPrayers(user, DateTime.now());

    return prayersAttended;
  }

  Stream previousPrayersStream() {
    return _databaseService.previousPrayersStream(user, DateTime.now());
  }

  Future getUserData() async {
    if (_databaseService.user == null) {
      user = await _databaseService.getUserData(getCurrentUser().uid);
    } else {
      user = _databaseService.user;
    }
    return user;
  }

  reportCOVIDCase() async {
    isLoading = true;

    notifyListeners();
    await _databaseService.reportCOVIDCase(user, prayersAttended);
    isLoading = false;

    notifyListeners();
    _dialogService.showDialog(
        title: 'Succesfully reported a COVID Case',
        description:
            'Thank you for reporting the COVID Case. Consequently all other musalees that you may have come into contact with will be informed.');
  }

  Future signOut() {
    isLoading = true;
    notifyListeners();

    _authService.signOut();

    isLoading = false;
    notifyListeners();
  }
}
