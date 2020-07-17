import 'package:mosque_attendance_app/app/locator.dart';
import 'package:mosque_attendance_app/services/DatabaseService.dart';
import 'package:mosque_attendance_app/services/FirebaseAuthService.dart';
import 'package:mosque_attendance_app/services/auth_service.dart';
import 'package:provider_architecture/_base_viewmodels.dart';

class AddUserDataViewModel extends BaseViewModel {
  bool isLoading = false;
  final DatabaseService _databaseService = locator<DatabaseService>();
  final FirebaseAuthService _authService = locator<FirebaseAuthService>();

  Future addUserData(String name, IDNo) async {
    User user = await _authService.getFirebaseUser();
    user.name = name;
    user.ID_number = IDNo;
    isLoading = true;
    notifyListeners();

    _databaseService.addUserData(user);
  }
}
