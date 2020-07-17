import 'package:firebase_auth/firebase_auth.dart';
import 'package:mosque_attendance_app/app/locator.dart';
import 'package:mosque_attendance_app/services/FirebaseAuthService.dart';
import 'package:mosque_attendance_app/services/auth_service.dart';

import 'package:stacked/stacked.dart';
import 'package:mosque_attendance_app/app/router.gr.dart';
import 'package:stacked_services/stacked_services.dart';

class RegisterViewModel extends BaseViewModel {
  String _title = 'Register View';
  String _greeting = "Assalamualykum";

  String _cellphonetitle = "Cellphone number";
  String _cellphonehintext = "+27.....";
  String _smsCodetitle = "SMS Code";
  String _smsCodeHintText = "6 digits";
  bool _isLoading = false;
  bool _smsCodeSent = false;
  String _info = "Please enter your cellphone number to register";

  String get smsInfo => _smsInfo;
  String _smsInfo = "Please enter the 6 digit code sent to your number";

  String _phoneno, _smsCode;
  String validationId;

  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseAuthService _authService = locator<FirebaseAuthService>();
  final DialogService _dialogService = locator<DialogService>();

  String get cellphonetitle => _cellphonetitle;

  bool get isLoading => _isLoading;

  String get greeting => _greeting;

  String get title => _title;

  String get info => _info;

  bool get smsCodeSent => _smsCodeSent;

  String get cellphonehintext => _cellphonehintext;

  String get smsCodetitle => _smsCodetitle;

  String get smsCodeHintText => _smsCodeHintText;

  set phoneno(String value) {
    _phoneno = value;
  }

  set smsCode(value) {
    _smsCode = value;
  }

  void showDialog() {
    _dialogService.showDialog(
      title: "test dialog",
      description: "Ma se poes",
    );
}

  Future verifyPhone(phoneNo) async {
    _isLoading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authResult) {
      _authService.signInwithPhoneNumber(authResult);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print('${authException.message}');
      _dialogService.showDialog(
        title: "Phone verification failed",
        description: authException.message,
      );
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.validationId = verId;
      _smsCodeSent = true;
      notifyListeners();
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.validationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);

    _isLoading = false;
    notifyListeners();
  }

  Future signInwithOTP(smsCode, verID) async {
    try {
      var authresult = await _authService.signInwithOTP(smsCode, validationId);
      if (authresult is String) {
        _dialogService.showDialog(
            title: "Verification failed",
            description: authresult,
            buttonTitle: "Dismiss");
      }
    } catch (e) {
      print(e.message);
    }
  }
}