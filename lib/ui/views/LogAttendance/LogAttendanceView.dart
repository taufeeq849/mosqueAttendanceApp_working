import 'package:flutter/material.dart';
import 'package:mosque_attendance_app/constants/constants.dart';
import 'package:mosque_attendance_app/models/Prayer.dart';
import 'package:mosque_attendance_app/services/Validator.dart';
import 'package:mosque_attendance_app/ui/views/LogAttendance/LogAttendanceViewModel.dart';
import 'package:stacked/stacked.dart';

class LogAttendanceView extends StatelessWidget {
  LogAttendanceView({this.prayer});

  LogAttendanceViewModel _logAttendanceViewModel = new LogAttendanceViewModel();
  Prayer prayer;
  GlobalKey<FormState> _cellnumkey = new GlobalKey<FormState>();
  String phonenumber;

  Widget _buildPhoneNumberTextbox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Phone numer",
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Form(
          key: _cellnumkey,
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: LogAttendanceInputStyle,
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

  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          if (_cellnumkey.currentState.validate()) {
            _cellnumkey.currentState.save();
            _logAttendanceViewModel.logAttendanceManually(phonenumber, prayer);
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blue,
        child: Text(
          'Save',
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
    // TODO: implement build
    return ViewModelBuilder<LogAttendanceViewModel>.reactive(
        builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                  boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.7))]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Please enter a phone number to log attendance for ${prayer.prayer_name}",
                      style: searchBarStyle,
                      textAlign: TextAlign.center,
                    ),
                    _buildPhoneNumberTextbox(),
                    _logAttendanceViewModel.isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : _buildSaveButton()
                  ],
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => _logAttendanceViewModel);
  }
}
