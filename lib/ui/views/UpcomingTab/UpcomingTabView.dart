import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mosque_attendance_app/app/locator.dart';
import 'package:mosque_attendance_app/constants/constants.dart';
import 'package:mosque_attendance_app/models/Prayer.dart';
import 'package:mosque_attendance_app/services/DatabaseService.dart';
import 'package:mosque_attendance_app/ui/views/LogAttendance/LogAttendanceView.dart';

import 'package:mosque_attendance_app/ui/views/UpcomingTab/UpcomingTabViewModel.dart';

import 'package:stacked/stacked.dart';

class UpcomingTabView extends StatelessWidget {
  final DatabaseService _databaseService = locator<DatabaseService>();
  final UpcomingTabViewModel _upcomingTabViewModel = new UpcomingTabViewModel();
  List<Prayer> _prayers;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpcomingTabViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Here is a list of today's upcoming prayers for Masjid-al-Furqaan",
                  style: headingStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                StreamBuilder(
                    stream: _upcomingTabViewModel.getUpcomingPrayersStream(),
                    builder: (context, snapshot) {
                      return FutureBuilder(
                        future: _upcomingTabViewModel.getPrayers(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.active ||
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            _prayers = snapshot.data;

                            if (_prayers.length == 0) {
                              return Center(
                                child: Text(
                                    "There are no scheduled prayers for today!", style: userDetailsStyle, textAlign: TextAlign.center,),
                              );
                            }
                            return ListView.builder(
                                itemCount: _prayers.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return PrayerTile(
                                    prayer: _prayers[index],
                                  );
                                });
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      );
                    })
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => _upcomingTabViewModel,
    );
  }
}

class PrayerTile extends StatelessWidget {
  PrayerTile({this.prayer});

  Prayer prayer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.white70, blurRadius: 10, spreadRadius: 5)
            ],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Prayer name: " + prayer.prayer_name,
              style: searchBarStyle,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
                "Commencing at: ${prayer.date.toString().substring(prayer.date.toString().indexOf(" "), prayer.date.toString().lastIndexOf(":"))}", style: prayerDetailStyle,),
            SizedBox(
              height: 10,
            ),
            Text("Current capacity: ${prayer.currentCapacity.toString()}", style: prayerDetailStyle,),
            SizedBox(
              height: 10,
            ),
            Text("Max capacity: ${prayer.maxCapacity.toString()}", style: prayerDetailStyle,),
            LogAttendanceButton(prayer: prayer,)
          ],
        ),
      ),
    );
  }
}

class LogAttendanceButton extends StatelessWidget {
  LogAttendanceButton({@required this.prayer});

  Prayer prayer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
        onTap: () {
          var bottomSheetController = showBottomSheet(
              context: context,
              builder: (context) {
                return LogAttendanceView(
                  prayer: prayer,
                );
              });
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular((20))),

          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Log attendance manually for this prayer",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
        ),
      ),
    );
    // TODO: implement build
  }
}
