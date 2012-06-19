//
//  Notification.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/18/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NotificationName(event) [NSString stringWithFormat:@"WWO%@Notification", event]
#define NotificationDataKey @"data"

@interface Notification : NSObject
+ (void) send:(NSString *) event;
+ (void) send:(NSString *) event withData:(NSObject *) data;
+ (void) on:(NSString *) event target:(id)target selector:(SEL)selector;
+ (void) off:(NSString *) event target:(id)target;
@end
