//
//  RegisterPushRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/3/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "RegisterPushTokenRequest.h"

@implementation RegisterPushTokenRequest

- (void) send:(NSData *) token
{
    NSString *pushToken = [self tokenDataToString:token];
    NSLog(@"APN token = %@", pushToken);
    
    NSString *url = [self fullUrl:@"push/register"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.accessToken, @"token",
                            pushToken, @"iphone_push_token", nil];
    
    [self sendToUrl:url withParams:params];

}

- (NSString *) tokenDataToString:(NSData *)data
{
    return [[[[data description]
       stringByReplacingOccurrencesOfString: @"<" withString: @""] 
      stringByReplacingOccurrencesOfString: @">" withString: @""] 
     stringByReplacingOccurrencesOfString: @" " withString: @""];
}

@end
