//
//  FetchConversationRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/8/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerGetRequest.h"
#import "Conversation.h"

@protocol FetchConversationRequestDelegate <NSObject>
- (void) didFetchConversation:(Conversation *)conversation;
@end

@interface FetchConversationRequest : ServerGetRequest
@property (assign) id <FetchConversationRequestDelegate> delegate;

- (void) send:(NSInteger) userID;
@end
