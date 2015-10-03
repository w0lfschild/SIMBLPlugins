//
//  loadZest.m
//  zestyWin
//
//  Created by Wolfgang Baird on 9/14/15.
//  Copyright © 2015 Wolfgang Baird. All rights reserved.
//

#import "loadZest.h"

loadZest *plugin;
NSUserDefaults *sharedPrefs;
NSDictionary *sharedDict;
bool enabled = true;

@implementation loadZest

+ (loadZest*) sharedInstance
{
    static loadZest* plugin = nil;
    
    if (plugin == nil)
        plugin = [[loadZest alloc] init];
    
    return plugin;
}

+ (void)load {
    plugin = [loadZest sharedInstance];
    NSInteger osx_ver = [[NSProcessInfo processInfo] operatingSystemVersion].minorVersion;
    // Don't do anything if user isn't running 10.10 or above
    if (osx_ver > 9) {
        [plugin zest_setupPrefs];
        // Check if application is blacklisted
        if ([sharedDict objectForKey:[[NSBundle mainBundle] bundleIdentifier]] != nil)
        {
            enabled = false;
        }
        // If application is not blacklisted add vibrant window to all current application windows
        if (enabled)
        {
            NSLog(@"OS X 10.%ld, zestyWin loaded...", (long)osx_ver);
            NSApplication *application = [NSApplication sharedApplication];
            if (application.windows)
            {
                for (NSWindow *win in application.windows)
                {
                    [plugin zest_addView:win];
                }
            }
        }
    }
}

- (void)zest_addView:(NSWindow*)theWindow {
    // Something else that can be foreced but just looks aweful 90% of the time (this is why dark mode only exists for a few select apps)
    // theWindow.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
    // theWindow.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    // [theWindow invalidateShadow];
    
    Class vibrantClass=NSClassFromString(@"NSVisualEffectView");
    if (vibrantClass)
    {
        bool addzest = true;
        // Look for existing instance of a vibrant view
        for (NSView *aVeiw in theWindow.contentView.subviews)
        {
            if ([[aVeiw identifier] isEqualToString:@"cView"])
            {
                addzest = false;
                break;
            }
        }
        // If not found add vibrant view
        if (addzest)
        {
            NSVisualEffectView *vibrant=[[vibrantClass alloc] initWithFrame:[[theWindow contentView] bounds]];
            [vibrant setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
            [vibrant setBlendingMode:NSVisualEffectBlendingModeBehindWindow];
            [vibrant setIdentifier:@"cView"];
            [[theWindow contentView] addSubview:vibrant positioned:NSWindowBelow relativeTo:nil];
        }
    }
}

-(void)zest_setKey:(NSString*)key {
    // Add application to blacklist if it doesn't already exist
    if ([sharedDict objectForKey:key] == nil)
    {
        // NSLog(@"Adding key: %@", key);
        [sharedPrefs setInteger:0 forKey:key];
    }
}

-(void)zest_setupPrefs {
    if (!sharedPrefs)
    {
        sharedPrefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.w0lf.zestyWin"];
        sharedDict = [sharedPrefs dictionaryRepresentation];
    }
    // Manual blacklist
    [plugin zest_setKey:@"com.apple.finder"];
    [plugin zest_setKey:@"com.apple.iTunes"];
    [plugin zest_setKey:@"com.apple.Terminal"];
    [plugin zest_setKey:@"com.sublimetext.2"];
    [plugin zest_setKey:@"com.sublimetext.3"];
    [plugin zest_setKey:@"org.w0lf.cDock"];
    // TextEdit is my favorite: Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'thanks, but I need to control my own subviews'
    [plugin zest_setKey:@"com.apple.TextEdit"];
    
    [sharedPrefs synchronize];
}

@end

ZKSwizzleInterface(_zest_NSWindow, NSWindow, NSResponder);
@implementation _zest_NSWindow

- (void)becomeKeyWindow {
    ZKOrig(void);
    // If the window gained focus check if it has a vibrant view or not and if doesn't add one
    if (enabled)
    {
        [plugin zest_addView:(NSWindow*)self];
    }
}

@end

