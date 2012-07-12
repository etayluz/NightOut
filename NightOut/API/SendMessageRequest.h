//
//  SendMessageRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/8/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerPostRequest.h"

@interface SendMessageRequest : ServerPostRequest
- (void) send:(NSInteger)conversationID message:(NSString *)message;
@end
