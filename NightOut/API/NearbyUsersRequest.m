//
//  WWONearbyUsersRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/17/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "NearbyUsersRequest.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

#import "User.h"

#define kWWOBaseURL @"http://nightapi.pagodabox.com/api/v1"
#define kWWOUrl(path)   [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kWWOBaseURL, (path)]];


@interface NearbyUsersRequest()
@property (nonatomic, retain) ASIHTTPRequest *request;
@end

@implementation NearbyUsersRequest

@synthesize request;

- (void) fetch
{
    if (!self.request) {
        NSLog(@"fetching request");
        NSURL *url = kWWOUrl(@"messages.json"); 
        NSLog(@"%@", url);
        self.request = [ASIHTTPRequest requestWithURL:url];
        self.request.delegate = self;
        self.request.timeOutSeconds = 2 * 60;
        [self.request startAsynchronous];
    }
}

- (NSURL *) buildUrl:(NSString *) path
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.baseUrl, path]];
}

- (NSString *) baseUrl
{
    return @"http://nightapi.pagodabox.com/api/v1";
}

- (void)requestFinished:(ASIHTTPRequest *)req
{
    NSLog(@"woo request finishhhheddd");
    //todo: status
    NSString *jsonString = req.responseString;
    NSDictionary *responseDict = [jsonString objectFromJSONString];
    //int status = [[responseDict objectForKey:@"status"] intValue];
    
    NSArray *userDicts = [responseDict objectForKey:@"users"];
    NSMutableArray *users = [NSMutableArray array];
    for (NSDictionary *userDict in userDicts) {
        User *user = [[[User alloc] initWithDictionary:userDict] autorelease];
        [users addObject: user];
    }
    
    [self raiseEvent:@"WWOApiManagerDidFetchNearbyUsersNotification" withData:users];
    self.request = nil;
}

- (void)requestFailed:(ASIHTTPRequest *)req
{
    NSLog(@"request failed");
}


- (void) raiseEvent:(NSString *) event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:event object:nil userInfo:nil];
}

- (void) raiseEvent:(NSString *) event withData:(NSObject *) data
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:data forKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName:event object:nil userInfo:userInfo];
}

@end
