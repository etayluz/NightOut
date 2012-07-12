//
//  FetchSmileGamesRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/12/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "FetchSmileGamesRequest.h"
#import "SmileGame.h"


@implementation FetchSmileGamesRequest : ServerGetRequest
@synthesize delegate;

- (void) sendWithStatus:(NSString *)status
{
    if (!self.request) {
        NSString *url = [NSString stringWithFormat:@"http://wwoapp.herokuapp.com/api/v1/smile-games/%@?token=%@", status, self.accessToken];
        NSLog(@"FetchSmileGamesRequest = %@", url);
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
