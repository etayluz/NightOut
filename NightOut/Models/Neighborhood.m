//
//  Neighborhood.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/27/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "Neighborhood.h"
#import "User.h"

@implementation Neighborhood

@synthesize users, name, currentUser;

- (void) dealloc
{
    self.name = nil;
    self.users = nil;
    self.currentUser = nil;
    
    [super dealloc];
}

- (id) initWithDictionary: (NSDictionary *) dictionary
{
    if (self = [self init]) {
        // grab neighborhood name
        self.name = [dictionary objectForKey:@"current_region"];
        
        // grab users
        self.users = [NSMutableArray array];
        NSArray *userDicts = [dictionary objectForKey:@"users"];
        for (NSDictionary *userDict in userDicts) {
            User *user = [[[User alloc] initWithDictionary:userDict] autorelease];
            [self.users addObject: user];
        }
        
        NSDictionary *currentUserDict = [dictionary objectForKey:@"current_user"];
        self.currentUser = [[[User alloc] initWithDictionary:currentUserDict] autorelease];
    }
    return self;
}

@end
