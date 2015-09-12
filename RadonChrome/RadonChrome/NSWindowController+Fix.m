//
//  NSWindowController+Fix.m
//  RadonChrome
//
//  Created by Preston Mueller on 1/24/15.
//  Copyright (c) 2015 Preston Mueller. All rights reserved.
//

#import "NSWindowController+Fix.h"

@implementation NSWindowController (Fix)

-(void)FIXshowWindow:(id)sender {
    
    if(![NSStringFromClass([self class]) isEqualToString:@"MCPopupController"])return [self FIXshowWindow:sender];

    NSString *title = nil;
    NSString *text = nil;
    
    NSArray *subviews = [[[self window] contentView] subviews];
    for(NSView *view in subviews) {
        if([NSStringFromClass([view class]) isEqualToString:@"NSView"]) {
            NSArray *popupSubviews = [view subviews];
            for(NSView *popupSubview in popupSubviews) {
                if([NSStringFromClass([popupSubview class]) isEqualToString:@"NSTextView"]) {
                    if(title == nil)title = [(NSTextView *)popupSubview string];
                    else if(text == nil)text = [(NSTextView *)popupSubview string];
                }
            }
        }
    }
    
    id notificationController = [self performSelector:@selector(notificationController) withObject:nil];
    RONotificationSingleton *singleton = [RONotificationSingleton sharedInstance];
    
    NSString *thisUUID = [NSUUID UUID].UUIDString;
    [singleton addController:notificationController forNotification:thisUUID];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = title;
    notification.informativeText = text;
    notification.soundName = NSUserNotificationDefaultSoundName;
    notification.userInfo = @{@"uuid" : thisUUID};

    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:singleton];
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

@end
