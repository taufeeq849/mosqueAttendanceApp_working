import 'package:flutter/services.dart';
import 'package:mosque_attendance_app/constants/constants.dart';
import 'package:mosque_attendance_app/services/auth_service.dart';
import 'package:mosque_attendance_app/ui/views/AddUserData/AddUserDataViewModel.dart';
import 'package:mosque_attendance_app/ui/views/Register/RegisterViewModel.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

class AddUserDataView extends StatelessWidget {
  String name, idno;
  final GlobalKey<FormState> _namekey = GlobalKey<FormState>();
  AddUserDataViewModel _viewModel = AddUserDataViewModel();
  final GlobalKey<FormState> _idNoKey = GlobalKey<FormState>();

  Widget _buildNameTextbox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Name",
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Form(
          key: _namekey,
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: registerScreenTextBoxStyle,
            height: 60.0,
            child: TextFormField(
              validator: (value) {
                var num = int.tryParse(value);
                if (value.isEmpty || !value.contains(" ")) {
                  return "Name is invalid";
                }
                return null;
              },
              onSaved: (value) {
                name = value;
              },
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                hintText: 'Enter your name',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSaveBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _namekey.currentState.validate();
          _idNoKey.currentState.validate();
          bool isValid = _namekey.currentState.validate() &&
              _idNoKey.currentState.validate();
          if (isValid) {
            _namekey.currentState.save();
            _idNoKey.currentState.save();
            _viewModel.addUserData(name, idno);
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color.fromRGBO(229, 203, 161, 1),
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
    return ViewModelBuilder<AddUserDataViewModel>.reactive(
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
                    "Please fill in the following details to complete your registration",
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
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildNameTextbox(),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _viewModel.isLoading
                        ? CircularProgressIndicator()
                        : _buildSaveBtn(),
                  )
                ],
              ),
            ),
          ]));
        });
  }
}
