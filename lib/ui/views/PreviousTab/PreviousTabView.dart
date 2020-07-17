import 'package:flutter/material.dart';
import 'package:mosque_attendance_app/constants/constants.dart';
import 'package:mosque_attendance_app/ui/views/PreviousTab/PreviousTabViewModel.dart';
import 'package:mosque_attendance_app/models/Prayer.dart';
import 'package:stacked/stacked.dart';

class PreviousTabView extends StatelessWidget {
  PreviousTabViewModel _previousTabViewModel = PreviousTabViewModel();
  Size size;
  Widget _buildPreviousPrayersColumn(List<Prayer> prayers) {
    bool dataFetchedCorrectly = prayers.length != 0; //prayers.length == 0;
    return Container(
      height: 400,
      child: Column(
        children: <Widget>[
          Text(
            "Previous Prayers attended: ",
            style: headingStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          dataFetchedCorrectly
              ? Expanded(
                  child: ListView.builder(
                      itemCount: prayers.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return PreviousPrayerTile(
                          prayer: prayers[index],
                        );
                      }),
                )
              : Text("No prayers found!")
        ],
      ),
    );
  }

  Widget _buildUserDetailsColumn() {
    return Column(
      children: <Widget>[
        Text(
          "Showing details for: ",
          style: headingStyle,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          _previousTabViewModel.user != null
              ? _previousTabViewModel.user.name
              : "Unable to fetch user data!",
          style: userDetailsStyle,
        )
      ],
    );
  }

  Widget _buildReportaCaseButton() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () {
            _previousTabViewModel.reportCOVIDCase();
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.blue,
          child: Text(
            'Report a COVID Case',
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

  Widget _buildSignOutButton() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () {
            _previousTabViewModel.signOut();
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.blue,
          child: Text(
            'Sign out',
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
    return ViewModelBuilder<PreviousTabViewModel>.reactive(
      builder: (context, model, child) {

        return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: _previousTabViewModel.getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    return _buildUserDetailsColumn();
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),
              _previousTabViewModel.user != null
                  ? StreamBuilder(
                      stream: _previousTabViewModel.previousPrayersStream(),
                      builder: (context, snapshot) {
                        return FutureBuilder(
                            future: _previousTabViewModel.getPreviousPrayers(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.active ||
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                List<Prayer> prayers = [];
                                if (snapshot.data != null) {
                                  prayers = snapshot.data;
                                }
                                return Column(
                                  children: <Widget>[
                                    _buildPreviousPrayersColumn(prayers),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    _previousTabViewModel.isLoading
                                        ? CircularProgressIndicator()
                                        : _buildReportaCaseButton(),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    _buildSignOutButton()
                                  ],
                                );
                              } else {
                                return Center(
                                    child: (CircularProgressIndicator()));
                              }
                            });
                      })
                  : Center(
                      child: Text("Error in retrieving data. "),
                    ),
            ],
          ),
        )),
      );
      },
      viewModelBuilder: () => PreviousTabViewModel(),
    );
  }
}

class PreviousPrayerTile extends StatelessWidget {
  Prayer prayer;

  PreviousPrayerTile({this.prayer});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  prayer.prayer_name,
                  style: userDetailsStyle,
                ),
                Text(
                  prayer.mosque_name,
                  style: userDetailsStyle,
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
                "Date: ${prayer.date.toString().substring(0, prayer.date.toString().lastIndexOf(":"))}",style: prayerDetailStyle,),
            Text(
                "Number of infected musalees: ${prayer.infectedCount.toString()}", style: prayerDetailStyle,)
          ],
        ),
      ),
    );
  }
}
