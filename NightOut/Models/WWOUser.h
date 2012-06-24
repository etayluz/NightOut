//
//  WWOUser.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WWOAsDictionary.h"

@interface WWOUser : NSObject <WWOAsDictionary>

@property (retain) NSNumber *userID;
@property (retain) NSString *name;
@property (retain) NSString *network;
@property (retain) NSNumber *age;
@property (retain) NSNumber *mutualFriends;
@property (retain) NSString *picture;
@property (retain) NSString *thumb;

@property (retain) NSString *hometown;
@property (retain) NSString *currentCity;
@property (retain) NSString *college;
@property (retain) NSString *interestedIn;
@property (retain) NSString *relationshipStatus;
@property (retain) NSString *work;

@property (retain) NSArray *music;
@property (retain) NSArray *interests;
@property (retain) NSArray *recentPlaces;

@end