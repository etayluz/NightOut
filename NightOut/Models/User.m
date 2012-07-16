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

@synthesize OID, conversationID, name, age, photos, thumb, network, mutualFriends;
@synthesize hometown, currentCity, college, interestedIn, relationshipStatus, work;
@synthesize music, interests, recentPlaces;

- (void) dealloc
{
    self.name = nil;
    self.age = nil;
    self.photos = nil;
    self.thumb = nil;
    self.network = nil;
    self.mutualFriends = nil;
    self.hometown = nil;
    self.currentCity = nil;
    self.college = nil;
    self.interestedIn = nil;
    self.relationshipStatus = nil;
    self.work = nil;
    self.music = nil;
    self.interests = nil;
    self.recentPlaces = nil;
    
    [super dealloc];
}

- (id) initWithDictionary: (NSDictionary *) dictionary
{
    if (self = [self init]) {
        self.OID = [[dictionary objectForKey:@"id"] integerValue];
        self.conversationID = [[dictionary objectForKey:@"conversation_id"] integerValue];
        
        self.name = [dictionary objectForKey:@"name"];
        
        if ([dictionary objectForKey:@"age"] != [NSNull null]) {
            self.age = [dictionary objectForKey:@"age"];
        }
        
        self.network = [dictionary objectForKey:@"networks"];
        self.photos = [dictionary objectForKey:@"photos"];
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

@end
