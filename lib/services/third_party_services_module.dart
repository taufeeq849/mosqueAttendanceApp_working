import 'package:injectable/injectable.dart';
import 'package:mosque_attendance_app/services/DatabaseService.dart';
import 'package:mosque_attendance_app/services/FirebaseAuthService.dart';
import 'package:mosque_attendance_app/services/auth_service.dart';
import 'package:stacked_services/stacked_services.dart';

@registerModule
abstract class ThirdPartyServicesModule {
  @lazySingleton
  NavigationService get navigationService;
  @lazySingleton
  DialogService get dialogService;
  @lazySingleton
  FirebaseAuthService get firebaseAuthService;
  @lazySingleton
  DatabaseService get databaseService;
}