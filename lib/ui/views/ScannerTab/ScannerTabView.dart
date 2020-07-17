import 'package:flutter/material.dart';
import 'package:mosque_attendance_app/constants/constants.dart';
import 'package:mosque_attendance_app/ui/views/GenerateQR/GenerateQRView.dart';
import 'package:mosque_attendance_app/ui/views/Home/HomeViewModel.dart';
import 'package:mosque_attendance_app/ui/views/ScannerTab/ScannerTabViewModel.dart';
import 'package:stacked/stacked.dart';

class ScannerTabView extends StatelessWidget {
  ScannerTabViewModel _scannerTabViewModel = ScannerTabViewModel();

  Widget _buildScanBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _scannerTabViewModel.scan();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blue,
        child: Text(
          'Scan a QR Code',
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
    _scannerTabViewModel.getCurrentUser();
    return ViewModelBuilder<ScannerTabViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                _scannerTabViewModel.generate_pressed
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 50, horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              "You can either scan a QR Code to register attendance for a prayer or generate a QR Code for a specific prayer.",
                              style: headingStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 100,),
                            _buildScanBtn(),
                            GenerateButton(
                              scannerTabViewModel: _scannerTabViewModel,
                            )
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => _scannerTabViewModel,
    );
  }
}

class GenerateButton extends StatelessWidget {
  GenerateButton({this.scannerTabViewModel});

  ScannerTabViewModel scannerTabViewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          scannerTabViewModel.updateOnPressed(true);
          var bottomSheetController = showBottomSheet(
              context: context,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: GenerateQRView(),
                );
              });
          bottomSheetController.closed
              .then((value) => scannerTabViewModel.updateOnPressed(false));
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blue,
        child: Text(
          'Generate a QR Code',
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
}
