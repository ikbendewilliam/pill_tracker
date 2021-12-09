// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:icapps_architecture/icapps_architecture.dart';

// Project imports:
import 'package:pill_tracker/util/env/flavor_config.dart';

class DummyApiUtil {
  static const _API_ASSET_PATH = 'assets/api';

  static Future<T> getResponse<T>(String url) async {
    if (!FlavorConfig.isDummy()) {
      throw ArgumentError('Failed to get dummy response while configuration is not dummy');
    }
    final path = '$_API_ASSET_PATH/$url.json';
    try {
      staticLogger.debug('---------------> GET - url: file://$path');

      final jsonString = await rootBundle.loadString(path);
      staticLogger.debug('<--------------- GET - url: file://$path - statucode: 200');
      return json.decode(jsonString) as T;
    } catch (e, stack) {
      staticLogger.error(
        '<--------------- GET - url: $path - statucode: 404',
        error: e,
        trace: stack,
      );
      rethrow;
    }
  }
}