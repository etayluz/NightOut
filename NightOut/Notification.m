//
//  Notification.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/18/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "Notification.h"

@implementation Notification

+ (void) send:(NSString *) event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName(event) object:nil userInfo:nil];
}

+ (void) send:(NSString *) event withData:(NSObject *) data
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:data forKey:NotificationDataKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName(event) object:nil userInfo:userInfo];
}

+ (void) registerNotification:(NSString *) event target:(id)target selector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:NotificationName(event) object:nil];
}

+ (void) unregisterNotification:(NSString *) event target:(id)target
{
    [[NSNotificationCenter defaultCenter] removeObserver:target name:NotificationName(event) object:nil];
}

@end
