//
//  GuessSmileGameChoiceRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "GuessSmileGameChoiceRequest.h"
#import "SmileGameChoice.h"


@implementation GuessSmileGameChoiceRequest
@synthesize delegate;

- (void) send:(NSInteger)smileGameID smileGameChoiceID:(NSInteger)smileGameChoiceID
{
    if (!self.request) {
        NSString *url = [self fullUrl:@"smile-games/%d/choices/%d/guess", smileGameID, smileGameChoiceID];
        
        [self sendToUrl:url];
    }
}

- (void) didFetchJson:(NSDictionary *)json
{
    NSDictionary *smileGameDict = [json objectForKey:@"smile_game"];
    SmileGame *smileGame = [[[SmileGame alloc] initWithDictionary:smileGameDict] autorelease ];
    [self.delegate didGuess:smileGame];
}

@end
