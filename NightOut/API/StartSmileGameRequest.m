//
//  StartSmileGameRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/13/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "StartSmileGameRequest.h"

@implementation StartSmileGameRequest
@synthesize delegate;

- (void) send:(NSInteger) userID
{
    NSString *url = [NSString stringWithFormat:@"http://wwoapp.herokuapp.com/api/v1/users/%d/start-smile-game?token=%@", userID, self.accessToken];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.accessToken, @"token", nil];
    [self sendToUrl:url withParams:params];
}

- (void) didFetchJson:(NSDictionary *)json
{
    [self.delegate didStartSmileGame];
}

@end
