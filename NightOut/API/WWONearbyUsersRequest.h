//
//  WWONearbyUsersRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/17/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"

@interface WWONearbyUsersRequest : NSObject <ASIHTTPRequestDelegate>
- (void) fetch;
@end
