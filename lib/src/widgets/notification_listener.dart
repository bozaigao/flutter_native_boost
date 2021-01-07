import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:g_json/g_json.dart';
import '../route/native_bridge.dart';

///
const _notificationChannel = MethodChannel('flutter_native_boost/notification');

final _notificationController =
    StreamController<ContainerNotification>.broadcast(onListen: () {
  debugPrint('_notificationController onlListened');
}, onCancel: () {
  debugPrint('_notificationController onCanceled');
});

StreamSubscription _observerNativeNotification(
    List<String> names, ValueChanged<ContainerNotification> onNotification) {
  return _notificationController.stream.listen((event) {
    if (names.contains(event.name)) onNotification(event);
  });
}

Future<bool> _handler(MethodCall call) {
  if (_notificationController.hasListener) {
    _notificationController.sink
        .add(ContainerNotification(call.method, call.arguments));
    return Future.value(true);
  }
  return Future.value(false);
}

/// ContainerNotification dispatched by native channel
class ContainerNotification {
  ///
  final String name;

  /// must encoding to json
  final dynamic arguments;

  ///
  ContainerNotification(this.name, [this.arguments])
      : assert(name.isNotEmpty),
        super();

  @override
  String toString() {
    if (kDebugMode) {
      return 'notification: $name: ${JSON(arguments).prettyString()}';
    }
    return super.toString();
  }

  /// 全局广播此通知
  void dispatchToGlobal({bool deliverToNative = true}) {
    if (_notificationController.hasListener) {
      _notificationController.sink.add(this);
    }
    if (deliverToNative) {
      _notificationChannel.invokeMethod(name, arguments);
    }
  }
}

// ignore: public_member_api_docs
typedef NotificationRecivedCallback = void Function(
    BuildContext? topMostContext, ContainerNotification value);

/// Receive native notification
class ContainerNotificationListener extends StatefulWidget {
  /// 想要监听的通知 名称数组
  /// 可以同时监听多个通知
  ///
  /// eg:
  ///
  /// ['ListUpdate', 'Logout']
  final List<String> names;

  ///
  final NotificationRecivedCallback onNotification;

  ///
  final Widget child;

  ///
  const ContainerNotificationListener(
    this.names, {
    Key? key,
    required this.onNotification,
    required this.child,
  }) : super(key: key);

  @override
  _ContainerNotificationListenerState createState() =>
      _ContainerNotificationListenerState();
}

class _ContainerNotificationListenerState
    extends State<ContainerNotificationListener> {
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    if (!_notificationChannel.checkMethodCallHandler(_handler)) {
      _notificationChannel.setMethodCallHandler(_handler);
    }
    _streamSubscription = _observerNativeNotification(widget.names, (value) {
      final bridge = ContainerNativeBridge.of(context);
      widget.onNotification(bridge?.topNavigator?.currentContext, value);
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
