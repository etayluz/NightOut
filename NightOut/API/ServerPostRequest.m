//
//  ServerRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/3/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerPostRequest.h"

@implementation ServerPostRequest

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
        [(ASIFormDataRequest *)self.request setPostValue:[params objectForKey:key] forKey:key];
    }
    
    [self.request startAsynchronous];
}

- (void) requestFinished:(ASIHTTPRequest *)_request
{
    [super requestFinished:_request];    
    self.request = nil;
}

- (void) requestFailed:(ASIHTTPRequest *)_request
{
    [super requestFailed:_request];
    self.request = nil;
}

@end
