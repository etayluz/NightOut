//
//  FetchUserRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/3/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerGetRequest.h"
#import "User.h"

@protocol FetchUserRequestDelegate <NSObject>
- (void) didFetchUser:(User *)user;
@end

@interface FetchUserRequest : ServerGetRequest
- (void) send: (NSInteger) userID;

@property (assign) id <FetchUserRequestDelegate> delegate;
@end
