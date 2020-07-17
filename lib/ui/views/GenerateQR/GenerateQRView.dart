import 'package:flutter/material.dart';
import 'package:mosque_attendance_app/constants/constants.dart';
import 'package:mosque_attendance_app/ui/views/GenerateQR/GenerateQRVIewModel.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stacked/stacked.dart';

class GenerateQRView extends StatelessWidget {
  GenerateQRViewModel _generateQRViewModel = GenerateQRViewModel();
  final DateTime now = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();

  Size size;

  Widget _buildSelectDateBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () async {
            TimeOfDay selectedtime =
                await showTimePicker(context: context, initialTime: timeOfDay, );
            _generateQRViewModel.updateSelectedTime(selectedtime);
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.blue,
          child: Text(
            _generateQRViewModel.selectedTime == null
                ? 'Pick a date and time'
                : 'Selected Time: ${_generateQRViewModel.selectedTime.hour}:${_generateQRViewModel.selectedTime.minute == 0 ? '00' : _generateQRViewModel.selectedTime.minute} ',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenerateBtn() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () async {
            _generateQRViewModel.generateQRCode();
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.blue,
          child: Text(
            'Generate QR Code',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () async {
            _generateQRViewModel.captureAndSharePng();
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.blue,
          child: Text(
            'Share this QR Code',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    this.size = MediaQuery.of(context).size;
    return ViewModelBuilder<GenerateQRViewModel>.reactive(
      viewModelBuilder: () => _generateQRViewModel,
      builder: (context, model, child) {
        _generateQRViewModel.buildContext = context;
        return Container(
          height: size.height / 1.25,
          decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7))]),
          child: Padding(
            padding: const EdgeInsets.all(34),
            child: model.QRCodeGenerated
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "QR Code for ${model.selectedprayer} at ${model.selectedTime.hour}:${model.selectedTime.minute == 0 ? '00' : model.selectedTime.minute} has been generated. Please allow musalees to scan this code in order for their attendance to be registered.",
                          style: searchBarStyle,
                          textAlign: TextAlign.center,
                        ),
                        _generateQRViewModel.QRImage,
                        SizedBox(
                          height: 30,
                        ),
                        _buildShareButton()
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Please select the following details to generate your QR Code",
                          style: headingStyle,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Which prayer is it? ",
                          style: searchBarStyle,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownButton(
                          value: model.selectedprayer,
                          items: model.buildDropDownMenuItems(),
                          onChanged: (value) => model.onDropdownSelect(value),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Please select the time that the prayer will begin:",
                          style: searchBarStyle,
                          textAlign: TextAlign.center,
                        ),
                        _buildSelectDateBtn(context),
                        model.isLoading
                            ? CircularProgressIndicator()
                            : _buildGenerateBtn()
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
