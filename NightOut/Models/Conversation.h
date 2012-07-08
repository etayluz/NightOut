//
//  Conversation.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/8/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsDictionary.h"

@interface Conversation : NSObject <AsDictionary>

@property (nonatomic) NSInteger currentUserID;
@property (nonatomic) NSInteger otherUserID;
@property (nonatomic, retain) NSMutableArray *messages;

@end
