//
//  NSWindowController+Fix.h
//  RadonChrome
//
//  Created by Preston Mueller on 1/24/15.
//  Copyright (c) 2015 Preston Mueller. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RONotificationSingleton.h"

@interface NSWindowController (Fix) <NSUserNotificationCenterDelegate>

-(void)FIXshowWindow:(id)sender;

@end
