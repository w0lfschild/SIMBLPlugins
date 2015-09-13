//
//  darkdock.m
//  darkdock
//
//  Created by Adam Bell on 2014-07-05.
//  Copyright (c) 2014 Adam Bell. All rights reserved.
//

#import "dlfcn.h"
#import "fishhook.h"
@import AppKit;

@interface darkdock : NSObject
@end

@implementation darkdock

static id (*orig_CFPreferencesCopyAppValue)(CFStringRef key, CFStringRef applicationID);

// Always return @"Dark" whenever @"AppleInterfaceTheme" is requested. @"AppleInterfaceTheme"'s value is stored in /Library/Preferences/.GlobalPreferences.
id hax_CFPreferencesCopyAppValue(CFStringRef key, CFStringRef applicationID) {
    if ([(__bridge NSString *)key isEqualToString:@"AppleInterfaceTheme"] || [(__bridge NSString *)key isEqualToString:@"AppleInterfaceStyle"]) {
        return @"Dark";
    } else {
        return orig_CFPreferencesCopyAppValue(key, applicationID);
    }
}

__attribute__((constructor))
static void goGoGadgetDarkMode() {
    // Use fishhook to do CoreFoundation hooks.
    orig_CFPreferencesCopyAppValue = dlsym(RTLD_DEFAULT, "CFPreferencesCopyAppValue");
    rebind_symbols((struct rebinding[1]){{"CFPreferencesCopyAppValue", hax_CFPreferencesCopyAppValue}}, 1);
    
    // Wait a few seconds for the Dock to warm up before firing a notification to reload the Dock colour.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), CFSTR("AppleInterfaceThemeChangedNotification"), (void *)0x1, NULL, YES);
    });
}

@end
