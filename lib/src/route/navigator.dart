import 'package:flutter/widgets.dart';

import 'arg.dart';
import 'native_bridge.dart';
import 'observer.dart';

/// ContainerNavigator is a root widget for each native container
class ContainerNavigator extends Navigator {
  ///
  final ContainerArguments arg;

  ///
  ContainerNavigator(
      {Key? key,
      PopPageCallback? onPopPage,
      required String initialRoute,
      required RouteListFactory onGenerateInitialRoutes,
      required RouteFactory onGenerateRoute,
      RouteFactory? onUnknownRoute,
      DefaultTransitionDelegate transitionDelegate =
          const DefaultTransitionDelegate<dynamic>(),
      required this.arg,
      List<NavigatorObserver>? observers})
      : super(
            key: key,
            onPopPage: onPopPage,
            initialRoute: initialRoute,
            onGenerateRoute: onGenerateRoute,
            onUnknownRoute: onUnknownRoute,
            onGenerateInitialRoutes: onGenerateInitialRoutes,
            transitionDelegate: transitionDelegate,
            observers: [
              arg.observer,
              if (observers != null) ...observers,
            ]);

  @override
  ContainerNavigatorState createState() => ContainerNavigatorState();

  ///
  static ContainerNavigatorState of(BuildContext context) {
    if (context is StatefulElement && context.state is ContainerNavigatorState) 
    {
      return context.state as ContainerNavigatorState;
    }
    // ignore: lines_longer_than_80_chars
    final container = context.findAncestorStateOfType<ContainerNavigatorState>();
    assert(container != null);
    return container!;
  }
}

///
class ContainerNavigatorState extends NavigatorState {
  late _ContainerWidgetsBindingObserver? _observerForAndroid;

  @override
  ContainerNavigator get widget => super.widget as ContainerNavigator;

  ///
  ContainerNavigatorObserver get observer => widget.arg.observer;

  @override
  void initState() {
    observer.disableHorizontalSwipePopGesture
        .addListener(notifyNativeDisableOrEnableBackGesture);
    _observerForAndroid = _ContainerWidgetsBindingObserver(this);
    WidgetsBinding.instance?.addObserver(_observerForAndroid!);
    super.initState();
  }

  @override
  void dispose() {
    observer.disableHorizontalSwipePopGesture
        .removeListener(notifyNativeDisableOrEnableBackGesture);
    if (_observerForAndroid != null) {
      WidgetsBinding.instance?.removeObserver(_observerForAndroid!);
      _observerForAndroid = null;
    }
    super.dispose();
  }

  ///
  void notifyNativeDisableOrEnableBackGesture() {
    ContainerNativeBridge.of(context)?.disableHorizontalSwipePopGesture(
        disable: observer.disableHorizontalSwipePopGesture.value);
  }

  @override
  Future<T?> pushNamed<T extends Object?>(String routeName,
      {Object? arguments}) {
    try {
      return super.pushNamed(routeName, arguments: arguments);
      // ignore: avoid_catching_errors
    } on FlutterError catch (e) {
      debugPrint('flutter_native_boost ContainerNavigator $e');
      debugPrint('fallback to native. name: $routeName, arguments: $arguments');

      final bridge = ContainerNativeBridge.of(context);
      assert(bridge != null);
      return bridge!.pushNamed<T>(routeName, arguments: arguments);
    }
  }

  @override
  void pop<T extends Object?>([T? result]) {
    if (observer.onlyOnePage) {
      ContainerNativeBridge.of(context)?.pop<Object>(widget.arg.key, result);
    } else {
      super.pop(result);
    }
  }

  @override
  Future<bool> maybePop<T extends Object?>([T? result]) async {
    final r = await super.maybePop(result);
    if (!r && observer.onlyOnePage) {
      pop(result);
      return true;
    }
    return r;
  }
}

class _ContainerWidgetsBindingObserver extends WidgetsBindingObserver {
  final ContainerNavigatorState navigator;

  _ContainerWidgetsBindingObserver(this.navigator);

  @override
  Future<bool> didPopRoute() async {
    final bridge = ContainerNativeBridge.of(navigator.context);
    assert(bridge != null);
    if (!bridge!.isOnTop(navigator.widget.arg.key)) {
      return false;
    }
    return await navigator.maybePop();
  }
}
