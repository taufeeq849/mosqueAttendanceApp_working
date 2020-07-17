import 'package:auto_route/auto_route_annotations.dart';
import 'package:mosque_attendance_app/LandingPage.dart';
import 'package:mosque_attendance_app/ui/views/Home/HomeView.dart';
import 'package:mosque_attendance_app/ui/views/Register/RegisterView.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  RegisterView registerViewRoute;
  HomeView homeViewRoute;
  LandingPage landingPageRoute;
}