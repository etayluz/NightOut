//
//  FetchAllConversationsRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/10/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerGetRequest.h"
#import "Conversation.h"

@protocol FetchAllConversationsRequestDelegate
- (void) didFetchAllConversations:(NSArray *)conversations;
@end

@interface FetchAllConversationsRequest : ServerGetRequest
@property (assign) id <FetchAllConversationsRequestDelegate> delegate;

- (void) send;
@end
