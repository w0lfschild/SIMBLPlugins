//
//  Load.m
//  _fulllscreenER
//
//  Created by Wolfgang Baird on 9/10/15.
//  Copyright © 2015 Wolfgang Baird. All rights reserved.
//

#import "load.h"
#import "ZKSwizzle.h"
@import AppKit;

BOOL _isMaximized = NO;
BOOL _willMaximize = NO;
struct CGRect _cachedFrame;

@implementation Load

+ (void)load {
    NSLog(@"OS X 10.11, _fullscreenER loaded...");
//    _cachedFrame = CGRectMake(0, 0, 0, 0);
    NSApplication *application = [NSApplication sharedApplication];
    if (application.windows)
    {
        for (NSWindow *win in application.windows)
        {
            win.styleMask = win.styleMask | NSResizableWindowMask;
//            [win setTitlebarAppearsTransparent:true];
            
//            Class vibrantClass=NSClassFromString(@"NSVisualEffectView");
//            if (vibrantClass)
//            {
//                NSVisualEffectView *vibrant=[[vibrantClass alloc] initWithFrame:[[win contentView] bounds]];
//                [vibrant setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
//                [vibrant setBlendingMode:NSVisualEffectBlendingModeBehindWindow];
//                [vibrant setIdentifier:@"w0blurView"];
//                if (![win.contentView.subviews containsObject:vibrant])
//                    [[win contentView] addSubview:vibrant positioned:NSWindowBelow relativeTo:nil];
//            }
            
            /*
             NSClosableWindowMask |
             NSTitledWindowMask | 
             NSMiniaturizableWindowMask | 
             NSTexturedBackgroundWindowMask | 
             NSResizableWindowMask | 
             NSFullSizeContentViewWindowMask;
             
             NSWindowFullScreenButton
             NSWindow *this = (NSWindow*)self;
             NSButton *windowButton = [this standardWindowButton:NSWindowZoomButton];
             NSButton *t = [[NSWindow alloc] standardWindowButton:NSWindowZoomButton];
             windowButton = t;
             
             */
           
        }
    }
}

@end

@interface NSWindow (Maximizer)
- (void)setFrame:(struct CGRect)arg1 display:(BOOL)arg2 animate:(BOOL)arg3;
- (struct CGRect)_tileFrameForFullScreen;
- (BOOL)_inFullScreen;
@end

ZKSwizzleInterface(_Maximize_NSWindow, NSWindow, NSResponder);
@implementation _Maximize_NSWindow

- (BOOL)_allowsFullScreen {
    return YES;
}

- (BOOL)canEnterFullScreenMode {
    return YES;
}

- (BOOL)showsFullScreenButton {
    return NO;
}

- (BOOL)_canEnterFullScreenOrTileMode {
    return YES;
}

- (BOOL)_canEnterTileMode {
    return YES;
}

- (BOOL)_allowedInOtherAppsFullScreenSpaceWithCollectionBehavior:(unsigned long long)arg1 {
    return YES;
}

- (BOOL)_hasActiveAppearanceForStandardWindowButton:(unsigned long long)arg1 {
    return YES;
}

// Full screen toggle
- (void)_W0fullScreen {
    NSWindow *this = (NSWindow*)self;
    [this toggleFullScreen:this];
}

// Fill screen toggle (will also exit fullscreen if currently fullscreen)
- (void)_W0fillScreen {
    NSWindow *this = (NSWindow*)self;
    
    if ([this _inFullScreen]) {

        [this toggleFullScreen:this];
        
    } else {
    
        if (!_isMaximized) {
            _isMaximized = YES;
            _cachedFrame = this.frame;
            [this setFrame:[this _tileFrameForFullScreen] display:true animate:true];
        } else {
            _isMaximized = NO;
            [this setFrame:_cachedFrame display:true animate:true];
        }
        
    }
}

- (BOOL)_zoomButtonIsFullScreenButton {
    NSWindow *this = (NSWindow*)self;
    
    if (([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask) == NSAlternateKeyMask) {
        [[this standardWindowButton:NSWindowZoomButton] setAction:@selector(_W0fullScreen)];
        [[this standardWindowButton:NSWindowZoomButton] setAlphaValue:.5 ];
//        NSLog(@"Fullscreen");
    } else {
        [[this standardWindowButton:NSWindowZoomButton] setAction:@selector(_W0fillScreen)];
        [[this standardWindowButton:NSWindowZoomButton] setAlphaValue:1 ];
//        NSLog(@"Plus");
    }
    
    return NO;
}
@end