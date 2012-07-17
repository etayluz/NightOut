//
//  ServerRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/3/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerPostRequest.h"
#import "JSONKit.h"

@implementation ServerPostRequest
@synthesize request;

- (void) sendToUrl:(NSString *)url
{
    NSURL *u = [NSURL URLWithString:url];
    self.request = [ASIFormDataRequest requestWithURL:u];
    self.request.delegate = self;
    [self.request startAsynchronous];
}

- (void) sendToUrl:(NSString *)url withParams:(NSDictionary *)params
{
    NSURL *u = [NSURL URLWithString:url];
    self.request = [ASIFormDataRequest requestWithURL:u];
    self.request.delegate = self;
    
    for (id key in params) {
        [self.request setPostValue:[params objectForKey:key] forKey:key];
    }
    
    [self.request startAsynchronous];
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = self.request.responseString;
    NSDictionary *responseDict = [jsonString objectFromJSONString];
    
    NSLog(@"response = %@", jsonString);
    
    [self didFetchJson:responseDict];
    
    self.request = nil;
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
    self.request = nil;
}

@end
