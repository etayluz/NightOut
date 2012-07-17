//
//  FetchSmileGameRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "FetchSmileGameRequest.h"
#import "SmileGame.h"

@implementation FetchSmileGameRequest
@synthesize delegate;

- (void) send:(NSInteger)smileGameID
{
    if (!self.request) {
        NSString *url = [self fullUrl:@"smile-games/%d", smileGameID];
        [self sendToUrl:url];
    }
}

- (void) didFetchJson:(NSDictionary *)json
{
    NSDictionary *smileGameDict = [json objectForKey:@"smile_game"];
    SmileGame *smileGame = [[[SmileGame alloc] initWithDictionary:smileGameDict] autorelease];
    [self.delegate didFetchSmileGame:smileGame];
}

@end
