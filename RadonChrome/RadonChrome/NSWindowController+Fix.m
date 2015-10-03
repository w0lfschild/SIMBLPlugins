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
    NSImage *img = nil;
    
    NSArray *subviews = [[[self window] contentView] subviews];
    for(NSView *view in subviews) {
        if([NSStringFromClass([view class]) isEqualToString:@"NSView"]) {
            NSArray *popupSubviews = [view subviews];
            for(NSView *popupSubview in popupSubviews) {
                if([NSStringFromClass([popupSubview class]) isEqualToString:@"NSTextView"]) {
                    if(title == nil)title = [(NSTextView *)popupSubview string];
                    else if(text == nil)text = [(NSTextView *)popupSubview string];
                } else if([NSStringFromClass([popupSubview class]) isEqualToString:@"AccessibilityIgnoredBox"]) {
                    if([[popupSubview subviews] count] > 0) {
                        NSView * imageView = [popupSubview subviews][0];
                        if([NSStringFromClass([imageView class]) isEqualToString:@"NSImageView"]) {
                            if(img == nil) {
                                img = [(NSImageView*)imageView image];
                            }
                        }
                    }
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
    if(img != nil) {
        [notification setValue:img forKey:@"_identityImage"];
        [notification setValue:@(NO) forKey:@"_identityImageHasBorder"];
    }
    
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:singleton];
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

@end