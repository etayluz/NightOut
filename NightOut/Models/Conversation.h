//
//  Conversation.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/8/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsDictionary.h"
#import "Message.h"
#import "User.h"

@interface Conversation : NSObject <AsDictionary>

@property (nonatomic) NSInteger OID;
@property (nonatomic) NSInteger currentUserID;
@property (nonatomic, retain) User *otherUser;
@property (nonatomic, retain) Message *latestMessage;
@property (nonatomic, retain) NSMutableArray *messages;

@end
