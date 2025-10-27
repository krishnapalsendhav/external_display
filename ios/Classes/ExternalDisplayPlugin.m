#import "ExternalDisplayPlugin.h"
#if __has_include(<external_screen/external_screen-Swift.h>)
#import <external_screen/external_screen-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "external_screen-Swift.h"
#endif

@implementation ExternalDisplayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [ExternalDisplayPlugin registerWithRegistrar:registrar];
}
@end