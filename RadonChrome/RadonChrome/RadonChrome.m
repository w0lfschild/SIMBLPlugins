//
//  RadonChrome.m
//  RadonChrome
//
//  Created by Preston Mueller on 1/24/15.
//  Copyright (c) 2015 Preston Mueller. All rights reserved.
//

#import <objc/objc-class.h>
#import "RadonChrome.h"
#import "NSWindowController+Fix.h"

@implementation RadonChrome

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        SEL oldSelector = @selector(showWindow:);
        SEL newSelector = @selector(FIXshowWindow:);
        Class class = NSClassFromString(@"NSWindowController");
        
        Method oldMethod = class_getInstanceMethod(class, oldSelector);
        Method newMethod = class_getInstanceMethod(class, newSelector);
        
        if(class_addMethod(class, oldSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        {
            class_replaceMethod(class, newSelector, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
        }
        else
        {
            method_exchangeImplementations(oldMethod, newMethod);
        }
        
        
    });
}


@end
