//
//  SmileGame.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/12/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

@interface SmileGame : NSObject <AsDictionary>

@property (nonatomic) NSInteger OID;

@property (nonatomic, retain) User *sender;
@property (nonatomic, retain) User *receiver;

@property (nonatomic) NSInteger guessesRemaining;

@property (nonatomic, retain) NSMutableArray *choices;

@end
