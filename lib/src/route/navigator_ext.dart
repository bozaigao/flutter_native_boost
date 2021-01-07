import 'package:flutter/widgets.dart';
import 'package:g_json/g_json.dart';
import './navigator.dart';
import 'native_bridge.dart';
import 'options.dart';

///
extension NavigatorStateX on NavigatorState {
  /// pop native flutter container
  Future<void> nativePop<T extends Object>([T? result]) {
    final bridge =ContainerNativeBridge.of(context);
    if (bridge != null) {
      final key = ContainerNavigator.of(context).widget.arg.key;
      return bridge.pop(key, result);
    }
    throw 'ContainerNativeBridge not found !! $context';
  }

  /// push native flutter container
  Future<T?> nativePushNamed<T extends Object>(String routeName,
      {Object? arguments, Options? options}) {
    final bridge =ContainerNativeBridge.of(context);
    if (bridge != null) {
      return bridge.pushNamed<T?>(routeName,
          arguments: arguments, options: options);
    }

    throw 'ContainerNativeBridge not found !! $context';
  }
}

/// extension route settings
extension ContainerRouteSettings on RouteSettings {
  ///
  /// eg:
  /// final arg = settings.toJson;
  /// final id = arg.id;
  /// final name = arg.name;
  /// final types = arg.types;
  ///
  dynamic get toJson => JSON(arguments);
}
