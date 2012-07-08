//
//  FetchConversationRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/8/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "FetchConversationRequest.h"
#import "Conversation.h"

@implementation FetchConversationRequest
@synthesize delegate;

- (void) send:(NSInteger) userID;

{
    if (!self.request) {
        NSString *url = [NSString stringWithFormat:@"http://wwoapp.herokuapp.com/api/v1/conversations/%d?token=%@", userID, self.accessToken];
        NSLog(@"url = %@", url);
        [self sendToUrl:url];
    }
}

- (void) didFetchJson:(NSDictionary *)json
{
    NSDictionary *conversationDict = [json objectForKey:@"conversation"];
    Conversation *conversation = [[[Conversation alloc] initWithDictionary:conversationDict] autorelease];
    [self.delegate didFetchConversation:conversation];
}

@end
