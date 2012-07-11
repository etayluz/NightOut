//
//  FetchAllConversationsRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/10/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "FetchAllConversationsRequest.h"

@implementation FetchAllConversationsRequest
@synthesize  delegate;

- (void) send;

{
    if (!self.request) {
        NSString *url = [NSString stringWithFormat:@"http://wwoapp.herokuapp.com/api/v1/conversations?token=%@", self.accessToken];
        [self sendToUrl:url];
    }
}

- (void) didFetchJson:(NSDictionary *)json
{
    NSMutableArray *conversations = [NSMutableArray array];
    
    for (NSDictionary *conversationDict in [json objectForKey:@"conversations"]) {
        Conversation *convo = [[[Conversation alloc] initWithDictionary:conversationDict] autorelease];
        [conversations addObject:convo];
    }
    [self.delegate didFetchAllConversations:conversations];
}

@end
