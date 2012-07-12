//
//  FetchSmileGamesRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/12/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerGetRequest.h"

@protocol FetchSmileGamesRequestDelegate <NSObject>
- (void) didFetchSmileGames:(NSMutableArray *)smileGames;
@end

#define SmileGameStatusSent @"sent"
#define SmileGameStatusReceived @"received"
#define SmileGameStatusMatch @"match"

@interface FetchSmileGamesRequest : ServerGetRequest
@property (assign) id <FetchSmileGamesRequestDelegate> delegate;
- (void) sendWithStatus:(NSString *)status;
@end
