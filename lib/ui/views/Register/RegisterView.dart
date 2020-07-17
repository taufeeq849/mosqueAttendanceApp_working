import 'package:flutter/services.dart';
import 'package:mosque_attendance_app/constants/constants.dart';
import 'package:mosque_attendance_app/services/Validator.dart';
import 'package:mosque_attendance_app/services/auth_service.dart';
import 'package:mosque_attendance_app/ui/views/Register/RegisterViewModel.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  String phonenumber, smscode;
  final GlobalKey<FormState> _cellnumkey = GlobalKey<FormState>();
  RegisterViewModel _viewModel = RegisterViewModel();
  final GlobalKey<FormState> _smsCodeKey = GlobalKey<FormState>();

  Widget _buildNumberTextbox(String hinttext, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Form(
          key: _cellnumkey,
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: registerScreenTextBoxStyle,
            height: 60.0,
            child: TextFormField(
              autovalidate: false,
              validator: (value) {

                if (Validator().validatePhoneNumber(value)) {
                  return "Enter a valid phone number";
                }
                return null;
              },
              onSaved: (value) {
                phonenumber = value;
              },
              keyboardType: TextInputType.phone,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                hintText: 'Enter your cellphone number',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSmsCodeInput(String hinttext, String title, valText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Form(
          key: _smsCodeKey,
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: registerScreenTextBoxStyle,
            height: 60.0,
            child: TextFormField(
              validator: (val) {
                if (val.isEmpty || val.length != 6) {
                  return valText;
                }
                return null;
              },
              onSaved: (value) {
                smscode = value;
              },
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                hintText: hinttext,
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRegisterBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          if (_viewModel.smsCodeSent) {
            if (_smsCodeKey.currentState.validate()) {
              _smsCodeKey.currentState.save();

              _viewModel.signInwithOTP(smscode, " ");
            }
          } else {
            if (_cellnumkey.currentState.validate()) {
              _cellnumkey.currentState.save();
              _viewModel.verifyPhone(phonenumber);
            }
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color.fromRGBO(229, 203, 161, 1),
        child: Text(
          _viewModel.smsCodeSent ? 'Verify' : 'Register',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.reactive(
        viewModelBuilder: () => _viewModel,
        builder: (context, model, child) {
          return Scaffold(
              body: Stack(fit: StackFit.expand, children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: AssetImage(
                          "assets/images/register_screen_picture.jpg"),
                      fit: BoxFit.fill)),
            ),
            SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(40),
                  ),
                  Text(
                    model.greeting,
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    _viewModel.smsCodeSent ? model.smsInfo : model.info,
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: model.smsCodeSent
                        ? _buildSmsCodeInput(model.smsCodeHintText,
                            model.smsCodetitle, "Invaid SMS CODE")
                        : _buildNumberTextbox(
                            model.cellphonehintext, model.cellphonetitle),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: model.isLoading
                        ? CircularProgressIndicator()
                        : _buildRegisterBtn(),
                  )
                ],
              ),
            ),
          ]));
        });
  }
}
