import 'package:flutter/material.dart';
import 'package:mosque_attendance_app/LandingPage.dart';
import 'package:mosque_attendance_app/app/locator.dart';


import 'package:mosque_attendance_app/app/router.gr.dart';
import 'package:stacked_services/stacked_services.dart';

void main(){
setupLocator();
runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      initialRoute: Routes.registerViewRoute,
      onGenerateRoute: Router().onGenerateRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
      theme: ThemeData(primaryColor: Colors.blue),
      home: LandingPage(),
    );
  }




}
