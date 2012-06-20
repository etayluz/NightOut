//
//  WWOUser.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "WWOUser.h"

@implementation WWOUser

@synthesize userID, name, age, thumb, network, friends;


- (id) initWithDictionary: (NSDictionary *) dictionary
{
    if (self = [self init]) {
        self.name = [dictionary objectForKey:@"name"];
        self.age = [dictionary objectForKey:@"age"];
        self.network = [dictionary objectForKey:@"networks"];
        self.friends = [dictionary objectForKey:@"friends"];
        self.userID = [dictionary objectForKey:@"userID"];
        self.thumb = [dictionary objectForKey:@"thumb"];
    }
    return self;
}

- (NSMutableDictionary *) toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:self.name forKey:@"name"];
    [dictionary setObject:self.age forKey:@"age"];
    [dictionary setObject:self.userID forKey:@"userID"];
    [dictionary setObject:self.thumb forKey:@"thumb"];
    
    return dictionary;
}

@end
