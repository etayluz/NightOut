//
//  FetchSmileGameRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerGetRequest.h"
#import "SmileGame.h"

@protocol FetchSmileGameRequestDelegate
- (void) didFetchSmileGame:(SmileGame *)smileGame;
@end

@interface FetchSmileGameRequest : ServerGetRequest
@property (assign) id <FetchSmileGameRequestDelegate> delegate;

- (void)send:(NSInteger)smileGameID;
@end
