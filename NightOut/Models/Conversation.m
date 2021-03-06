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

@synthesize OID, currentUserID, otherUser;
@synthesize latestMessage, messages;

- (void) dealloc
{
    self.messages = nil;
    
    [super dealloc];
}

- (id) initWithDictionary: (NSDictionary *) dictionary
{
    if (self = [self init]) {
        self.OID = [[dictionary objectForKey:@"id"] integerValue];
        self.currentUserID = [[dictionary objectForKey:@"current_user_id"] integerValue];
        
        self.otherUser = [[[User alloc] initWithDictionary:[dictionary objectForKey:@"other_user"]] autorelease];
        
        if ([dictionary objectForKey:@"latest_message"] != [NSNull null])
        self.latestMessage = [[[Message alloc] initWithDictionary:[dictionary objectForKey:@"latest_message"]]autorelease];
        
        self.messages = [NSMutableArray array];
        NSDictionary *messageDicts = [dictionary objectForKey:@"messages"];
        for (NSDictionary *curMsgDict in messageDicts) {
            Message *message = [[[Message alloc] initWithDictionary:curMsgDict] autorelease];
            [self.messages addObject:message];
        }
    }
    return self;
}

@end
