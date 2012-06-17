//
//  WWOUser.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWOUser : NSObject

//todo: make it a protocol
- (id) initWithDictionary: (NSDictionary *) dictionary;
- (NSMutableDictionary *) toDictionary;

@property (retain) NSNumber *userID;
@property (retain) NSString *name;
@property (retain) NSNumber *age;
@property (retain) NSString *thumb;

@end