// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:mosque_attendance_app/services/third_party_services_module.dart';
import 'package:mosque_attendance_app/services/DatabaseService.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mosque_attendance_app/services/FirebaseAuthService.dart';
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  g.registerLazySingleton<DatabaseService>(
      () => thirdPartyServicesModule.databaseService);
  g.registerLazySingleton<DialogService>(
      () => thirdPartyServicesModule.dialogService);
  g.registerLazySingleton<FirebaseAuthService>(
      () => thirdPartyServicesModule.firebaseAuthService);
  g.registerLazySingleton<NavigationService>(
      () => thirdPartyServicesModule.navigationService);
}

class _$ThirdPartyServicesModule extends ThirdPartyServicesModule {
  @override
  DatabaseService get databaseService => DatabaseService();
  @override
  DialogService get dialogService => DialogService();
  @override
  FirebaseAuthService get firebaseAuthService => FirebaseAuthService();
  @override
  NavigationService get navigationService => NavigationService();
}
