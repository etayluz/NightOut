//
//  FetchUserRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/3/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "FetchUserRequest.h"

@implementation FetchUserRequest : ServerGetRequest
@synthesize delegate;


- (void) send: (NSInteger) userID
{
    if (!self.request) {
        NSString *url = [self fullUrl:@"users/%d", userID];
        [self sendToUrl:url];
    }
}

- (void) sendForCurrentUser
{
    if (!self.request) {
        NSString *url = [self fullUrl:@"me"];
        [self sendToUrl:url];
    }
}

- (void) didFetchJson:(NSDictionary *)json
{
    NSDictionary *userDict = [json objectForKey:@"user"];
    User *user = [[[User alloc] initWithDictionary:userDict] autorelease];
    [self.delegate didFetchUser:user];
}

@end
