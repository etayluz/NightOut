//
//  StartSmileGameRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/13/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerPostRequest.h"

@protocol StartSmileGameRequestDelegate
- (void) didStartSmileGame;
@end

@interface StartSmileGameRequest : ServerPostRequest
@property (assign) id <StartSmileGameRequestDelegate> delegate;

- (void) send:(NSInteger) userID;
@end
