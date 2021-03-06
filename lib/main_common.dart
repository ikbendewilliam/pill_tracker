// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Project imports:
import 'package:pill_tracker/architecture.dart';
import 'package:pill_tracker/util/web/non_web_configurator.dart' if (dart.library.html) 'package:pill_tracker/util/web/web_configurator.dart';

Future<void> _setupCrashLogging({required bool enabled}) async {
  if (enabled) {
    await Firebase.initializeApp();
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enabled);
    unawaited(FirebaseCrashlytics.instance.sendUnsentReports());
  }

  final originalOnError = FlutterError.onError;
  FlutterError.onError = (errorDetails) async {
    if (enabled) {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
    originalOnError?.call(errorDetails);
  };
}

FutureOr<R>? wrapMain<R>(FutureOr<R> Function() appCode, {required bool enableCrashLogging}) {
  return runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    configureWebApp();
    await _setupCrashLogging(enabled: enableCrashLogging);
    await initArchitecture();

    return await appCode();
  }, (object, trace) {
    WidgetsFlutterBinding.ensureInitialized();
    if (enableCrashLogging) {
      FirebaseCrashlytics.instance.recordError(object, trace);
    }
  });
}
