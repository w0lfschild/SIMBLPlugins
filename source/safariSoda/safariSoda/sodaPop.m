//
//  sodaPop.m
//  safariSoda
//
//  Created by Wolfgang Baird on 9/14/15.
//  Copyright © 2015 Wolfgang Baird. All rights reserved.
//

#include "ZKSwizzle.h"
@import AppKit;

@interface sodaPop : NSObject
@end

@interface _sweetclass : NSObject
- (id)menuForEvent:(id)arg1;
@end

@interface BrowserWindowControllerMac : NSWindowController
- (void)reloadAllTabs:(id)arg1;
@end

@interface BrowserWindow : NSWindow
@end

NSInteger osx_ver;
sodaPop *pluginInstance;

@implementation sodaPop

+ (sodaPop*) sharedInstance
{
    static sodaPop* plugin = nil;
    
    if (plugin == nil)
        plugin = [[sodaPop alloc] init];
    
    return plugin;
}

+(void)load {
    pluginInstance = [sodaPop sharedInstance];
    osx_ver = [[NSProcessInfo processInfo] operatingSystemVersion].minorVersion;
    NSLog(@"OS X 10.%ld, sodaPop loaded...", (long)osx_ver);
    ZKSwizzle(_sweetclass, TabBarView);
    NSApplication *application = [NSApplication sharedApplication];
    NSMenu *menu = application.windowsMenu;
    NSMenuItem *myitem = [[NSMenuItem alloc] initWithTitle:@"Reload All Tabs" action:@selector(wb_refreshmyTabs) keyEquivalent:@"X"];
    [myitem setKeyEquivalentModifierMask: NSCommandKeyMask];
    [myitem setTarget:pluginInstance];
    [menu insertItem:myitem atIndex:6]; // hardcoding index probably bad
}

-(void)wb_refreshmyTabs {
    NSApplication *application = [NSApplication sharedApplication];
    if (application.windows)
    {
        for (BrowserWindow *win in application.windows)
        {
            if ([win isKindOfClass:NSClassFromString(@"BrowserWindow")])
            {
                BrowserWindowControllerMac *wc = [win windowController];
                [wc reloadAllTabs:wc];
            }
        }
    }
}

@end

@implementation _sweetclass
- (id)menuForEvent:(id)arg1 {
//    NSLog(@"%@", ZKOrig(id, arg1));
    
    NSMenu *SodaMenu = ZKOrig(id, arg1);
    NSMenuItem *myitem = [[NSMenuItem alloc] initWithTitle:@"Reload All Tabs" action:@selector(wb_refreshmyTabs) keyEquivalent:@""];
    [myitem setTarget:pluginInstance];
    [SodaMenu addItem:myitem];
    return SodaMenu;
}
@end
