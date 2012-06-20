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
@property (retain) NSNumber *friends;
@property (retain) NSString *thumb;

@end