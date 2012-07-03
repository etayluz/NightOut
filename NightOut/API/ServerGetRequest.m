//
//  ServerRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/3/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerGetRequest.h"
#import "ServerInterface.h"
#import "JSONKit.h"
#import "ASIHTTPRequest.h"

@implementation ServerGetRequest

@synthesize request;
@synthesize accessToken;

- (NSString *) accessToken
{
    return [ServerInterface sharedManager].facebook.accessToken;
}

- (void) sendToUrl:(NSString *)url
{
    NSURL *u = [NSURL URLWithString:url];
    self.request = [ASIHTTPRequest requestWithURL:u];
    self.request.delegate = self;
    [self.request startAsynchronous];
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = self.request.responseString;
    NSDictionary *responseDict = [jsonString objectFromJSONString];
    [self didFetchJson:responseDict];
    
    self.request = nil;
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
    self.request = nil;
}

- (void) didFetchJson:(NSDictionary *)json
{
    // to be overridden
}

@end
