//
//  SmileGameChoice.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "SmileGameChoice.h"

@implementation SmileGameChoice
@synthesize OID, smileGameID, status, position, user;

- (id) initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [self init]) {
        self.OID = [[dictionary objectForKey:@"id"] integerValue];
        self.smileGameID = [[dictionary objectForKey:@"smile_game_id"] integerValue];
        self.status = [dictionary objectForKey:@"status"];
        self.position = [[dictionary objectForKey:@"position"] integerValue];
        
        self.user = [[[User alloc] initWithDictionary:[dictionary objectForKey:@"user"]] autorelease];
    }
    return self;
}

@end
