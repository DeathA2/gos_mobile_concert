import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_concert/firebase_options.dart';
import 'package:mobile_concert/src/app.dart';
import 'package:mobile_concert/src/locator.dart';

Future main() async {
  await initializeApp(
    name: "production",
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
  if (kIsWeb) {
    runApp(const MyApp());
  } else {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    runApp(const MyApp());
  }
}
