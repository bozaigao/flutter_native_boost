// ignore_for_file: public_member_api_docs

import 'package:flutter/services.dart';

const _channel = MethodChannel('flutter_native_boost/common');

class ContainerCommon {
  const ContainerCommon();

  static Future<T?> invokeMethod<T>(String method, [dynamic arguments]) {
    return _channel.invokeMethod(method, arguments);
  }

  static Future<List<T>?> invokeListMethod<T>(String method,
      [dynamic arguments]) {
    return _channel.invokeListMethod(method, arguments);
  }

  static Future<Map<K, V>?> invokeMapMethod<K, V>(String method,
      [dynamic arguments]) {
    return _channel.invokeMapMethod(method, arguments);
  }
}

// decorate class
const common = ContainerCommon();

class _ContainerCommonIgnoreMethod {
  const _ContainerCommonIgnoreMethod();
}

// decorate method
const ignore = _ContainerCommonIgnoreMethod();
