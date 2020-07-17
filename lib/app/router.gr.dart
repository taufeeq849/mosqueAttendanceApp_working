// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mosque_attendance_app/ui/views/Register/RegisterView.dart';
import 'package:mosque_attendance_app/ui/views/Home/HomeView.dart';
import 'package:mosque_attendance_app/LandingPage.dart';

abstract class Routes {
  static const registerViewRoute = '/';
  static const homeViewRoute = '/home-view-route';
  static const landingPageRoute = '/landing-page-route';
  static const all = {
    registerViewRoute,
    homeViewRoute,
    landingPageRoute,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.registerViewRoute:
        return MaterialPageRoute<dynamic>(
          builder: (context) => RegisterView(),
          settings: settings,
        );
      case Routes.homeViewRoute:
        return MaterialPageRoute<dynamic>(
          builder: (context) => HomeView(),
          settings: settings,
        );
      case Routes.landingPageRoute:
        return MaterialPageRoute<dynamic>(
          builder: (context) => LandingPage(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}
