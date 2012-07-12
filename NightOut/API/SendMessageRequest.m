//
//  SendMessageRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/8/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "SendMessageRequest.h"

@implementation SendMessageRequest

- (void) send:(NSInteger)conversationID message:(NSString *)message
{
    NSString *url = [NSString stringWithFormat:@"http://wwoapp.herokuapp.com/api/v1/conversations/%d/send", conversationID];
    NSLog(@"url = %@", url);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.accessToken, @"token", message, @"body", nil];
    
    [self sendToUrl:url withParams:params];
}

- (void) didFetchJson:(NSDictionary *)json
{
    NSLog(@"DidSendMessage");
}

@end
