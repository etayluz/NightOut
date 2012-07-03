//
//  FetchUserRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/3/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "FetchUserRequest.h"

@implementation FetchUserRequest : ServerRequest
@synthesize delegate;


- (void) send: (NSInteger) userID
{
    if (!self.request) {
        NSString *url = [NSString stringWithFormat:@"http://wwoapp.herokuapp.com/api/v1/users/%d?token=%@", userID, self.accessToken];
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
