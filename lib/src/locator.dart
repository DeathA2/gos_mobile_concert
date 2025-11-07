import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_concert/src/config/devices/app_info.dart';
import 'package:mobile_concert/src/config/env/env.dart';
import 'package:mobile_concert/src/features/home/cubit/home_cubit.dart';
import 'package:mobile_concert/src/router/router.dart';
import 'package:mobile_concert/src/services/remote_config/remote_config_service.dart';
import 'package:mobile_concert/src/services/user_prefs.dart';

import 'features/common/app_bloc/bloc_observer.dart';
import 'services/firebase_message.dart';

Future initializeApp({String? name, FirebaseOptions? firebaseOptions}) async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  _locator();
  await Firebase.initializeApp(name: name, options: firebaseOptions);
  await Future.wait([
    AppInfo.initialize(),
    UserPrefs.instance.initialize(),
    XFirebaseMessage.instance.initialize(),
    ENV.I.load('.env.$name'),
  ]);
  await RemoteConfigService.getRemoteConfig();

  Bloc.observer = XBlocObserver();
  // Bloc.transformer = XEventTransformer(),
}

void _locator() {
  GetIt.I.registerLazySingleton(() => AppRouter());
  GetIt.I.registerLazySingleton(() => HomeCubit());
}
