import Flutter
import UIKit

public class SwiftFNBoostPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        Container.default.setup(messenger: registrar.messenger())
    }
}
