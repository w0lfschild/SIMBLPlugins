//
//  RONotificationSingleton.m
//  RadonChrome
//
//  Created by Preston Mueller on 1/27/15.
//  Copyright (c) 2015 Preston Mueller. All rights reserved.
//

#import "RONotificationSingleton.h"

@implementation RONotificationSingleton

@synthesize notifications;

+ (RONotificationSingleton *)sharedInstance {
    static dispatch_once_t once;
    static RONotificationSingleton *instance;
    dispatch_once(&once, ^{
        instance = [[RONotificationSingleton alloc] init];
    });
    return instance;
}

-(id)init {
    if ( self = [super init] ) {
        notifications = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)addController:(id)controller forNotification:(NSString *)uuid {
    [notifications setObject:controller forKey:uuid];
}

-(BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    
    id controller = nil;
    
    for(NSString *key in [notifications allKeys]) {
        if([key isEqualToString:[notification.userInfo objectForKey:@"uuid"]]) {
            controller = [notifications objectForKey:key];
        }
    }
    if(controller != nil)
        [controller performSelector:@selector(notificationClicked) withObject:nil];

    if(notification) {
        [center removeDeliveredNotification:notification];
    }
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification
{
    //Do nothing
}

@end