//
//  WWOUser.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "User.h"
#import "AsDictionary.h"

@implementation User : NSObject

@synthesize userID, name, age, pictures, thumb, network, mutualFriends;
@synthesize hometown, currentCity, college, interestedIn, relationshipStatus, work;
@synthesize music, interests, recentPlaces;

- (id) initWithDictionary: (NSDictionary *) dictionary
{
    if (self = [self init]) {
        self.userID = [[dictionary objectForKey:@"id"] integerValue];
        self.name = [dictionary objectForKey:@"name"];
        self.age = [dictionary objectForKey:@"age"];
        self.network = [dictionary objectForKey:@"networks"];
        self.pictures = [dictionary objectForKey:@"photos"];
        self.thumb = [dictionary objectForKey:@"thumb"];
        
        self.currentCity = [dictionary objectForKey:@"current_city"];
        self.hometown = [dictionary objectForKey:@"hometown"];
        self.college = [dictionary objectForKey:@"college"];
        self.interestedIn = [dictionary objectForKey:@"interested_in"];
        self.relationshipStatus = [dictionary objectForKey:@"relationship_status"];
        self.work = [dictionary objectForKey:@"work"];
        
        self.mutualFriends = [dictionary objectForKey:@"mutual_friends"];
        self.interests = [dictionary objectForKey:@"interests"];
        self.music = [dictionary objectForKey:@"music"];
        self.recentPlaces = [dictionary objectForKey:@"recent_places"];
        
    }
    return self;
}

- (NSMutableDictionary *) toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:self.name forKey:@"name"];
    [dictionary setObject:self.age forKey:@"age"];
    [dictionary setObject:[NSNumber numberWithInt:self.userID] forKey:@"userID"];
    [dictionary setObject:self.thumb forKey:@"thumb"];
    
    return dictionary;
}

@end
