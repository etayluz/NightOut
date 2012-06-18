//
//  WWOApiManager.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequestDelegate.h"

#define kWWOBaseURL @"http://nightapi.pagodabox.com/api/v1"
#define kWWOUrl(path)   [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kWWOBaseURL, (path)]];

@interface WWOApiManager : NSObject <ASIHTTPRequestDelegate>

+ (WWOApiManager *)sharedManager;
- (void) fetchMessages;
- (void) fetchNearbyUsers;

@end

#define WWOApiManagerDidFetchMessagesNotification @"WWODidFetchMessagesNotification"

#define WWOApiManagerFailedToFetchMessagesNotification @"WWOFailedToFetchMessagesNotification"

#define WWOApiManagerDidFetchNearbyUsersNotification @"WWODidFetchNearbyUsersNotification"
