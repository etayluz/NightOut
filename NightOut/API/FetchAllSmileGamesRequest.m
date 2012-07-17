//
//  FetchSmileGamesRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/12/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "FetchAllSmileGamesRequest.h"
#import "SmileGame.h"


@implementation FetchAllSmileGamesRequest : ServerGetRequest
@synthesize delegate;

- (void) sendWithStatus:(NSString *)status
{
    if (!self.request) {
        NSString *url = [self fullUrl:@"smile-games-%@", status];
        [self sendToUrl:url];
    }
}

- (void) didFetchJson:(NSDictionary *)json
{
    NSMutableArray *smileGames = [NSMutableArray array];
    
    NSArray *smileGameDicts = [json objectForKey:@"smile_games"];
    for (NSDictionary *curSmileGameDict in smileGameDicts) {
        SmileGame *smileGame = [[[SmileGame alloc] initWithDictionary:curSmileGameDict] autorelease];
        [smileGames addObject:smileGame];
    }
    
    [self.delegate didFetchSmileGames:smileGames];
}

@end
