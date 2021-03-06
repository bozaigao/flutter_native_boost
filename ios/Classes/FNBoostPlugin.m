#import "FNBoostPlugin.h"
#if __has_include(<flutter_native_boost/flutter_native_boost-Swift.h>)
#import <flutter_native_boost/flutter_native_boost-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "SwiftFNBoostPlugin-Swift.h"
#endif

@implementation FNBoostPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFNBoostPlugin registerWithRegistrar:registrar];
}
@end
