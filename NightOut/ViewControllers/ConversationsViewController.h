//
//  ConversationsViewController.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/9/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Conversation.h"
#import "FetchAllConversationsRequest.h"

@interface ConversationsViewController : UITableViewController <FetchAllConversationsRequestDelegate>

@property (nonatomic, retain) NSArray *conversations;

@property (nonatomic, retain) FetchAllConversationsRequest *fetchAllConversationsRequest;

@end
