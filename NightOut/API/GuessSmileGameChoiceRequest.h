//
//  GuessSmileGameChoiceRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerPostRequest.h"
#import "SmileGame.h"

@protocol GuessSmileGameChoiceRequestDelegate <NSObject>
- (void) didGuess:(SmileGame *)smileGame;
@end

@interface GuessSmileGameChoiceRequest : ServerPostRequest
@property (assign) id <GuessSmileGameChoiceRequestDelegate> delegate;

- (void) send:(NSInteger)smileGameID smileGameChoiceID:(NSInteger)smileGameChoiceID;
@end
