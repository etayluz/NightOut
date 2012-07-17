//
//  ServerRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/3/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerGetRequest.h"
#import "ServerInterface.h"
#import "ASIHTTPRequest.h"

@implementation ServerGetRequest

- (void) sendToUrl:(NSString *)url
{
    NSURL *u = [NSURL URLWithString:url];
    self.request = [ASIHTTPRequest requestWithURL:u];
    self.request.delegate = self;
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

- (void) didFetchJson:(NSDictionary *)json
{
    // to be overridden
}

@end
