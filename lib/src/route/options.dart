import 'package:g_json/g_json.dart';

///
class Options {
  final JSON _raw;

  /// raw options
  Map<String, dynamic> get raw => _raw.mapObject ?? {};

  ///
  Options([Map<String, dynamic>? value]) : _raw = JSON(value ?? {});

  /// enable/disable animation
  void disableAnimation() => add(key: '_container.animated', value: false);

  /// show container with/without present
  void present() => add(key: '_container.present', value: true);

  /// is flutter route
  void flutterRoute() => add(key: '_container.flutter', value: true);

  /// add more options
  void add({required String key, required dynamic value}) {
    _raw[key] = value;
  }
}
