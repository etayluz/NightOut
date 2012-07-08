//
//  Conversation.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/8/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "Conversation.h"
#import "Message.h"

@implementation Conversation
@synthesize currentUserID, otherUserID;
@synthesize messages;

- (void) dealloc
{
    self.messages = nil;
    
    [super dealloc];
}

- (id) initWithDictionary: (NSDictionary *) dictionary
{
    if (self = [self init]) {
        self.currentUserID = [[dictionary objectForKey:@"current_user_id"] integerValue];
        self.otherUserID = [[dictionary objectForKey:@"other_user_id"] integerValue];
        
        self.messages = [NSMutableArray array];
        NSDictionary *messageDicts = [dictionary objectForKey:@"messages"];
        for (NSDictionary *curMsgDict in messageDicts) {
            Message *message = [[[Message alloc] initWithDictionary:curMsgDict] autorelease];
            [self.messages addObject:message];
        }
    }
    return self;
}

- (NSMutableDictionary *) toDictionary
{
    return nil;
}


@end
