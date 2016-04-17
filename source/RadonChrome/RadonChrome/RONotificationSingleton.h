//
//  RONotificationSingleton.h
//  RadonChrome
//
//  Created by Preston Mueller on 1/27/15.
//  Copyright (c) 2015 Preston Mueller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RONotificationSingleton : NSObject <NSUserNotificationCenterDelegate> {
    NSMutableDictionary *notifications;
    
}


@property (nonatomic, retain) NSMutableDictionary *notifications;

+ (RONotificationSingleton *)sharedInstance;
-(void)addController:(id)controller forNotification:(NSString *)uuid;


@end
