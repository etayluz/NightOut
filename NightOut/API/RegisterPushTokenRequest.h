//
//  RegisterPushRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/3/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerPostRequest.h"

@interface RegisterPushTokenRequest : ServerPostRequest

- (void) send:(NSData *) location;

@end
