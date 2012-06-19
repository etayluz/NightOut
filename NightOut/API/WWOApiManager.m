//
//  WWOApiManager.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "WWOApiManager.h"
#import "JSONKit.h"
#import "Notification.h"

#import "WWOMessage.h"
#import "WWOUser.h"

#import "WWONearbyUsersRequest.h"

@interface WWOApiManager ()

@property (nonatomic, retain) ASIHTTPRequest *messagesRequest;
@property (nonatomic, retain) ASIHTTPRequest *nearbyUsersRequest;

@end

static WWOApiManager *sharedManager = nil;

@implementation WWOApiManager
@synthesize messagesRequest, nearbyUsersRequest;

#pragma mark - Singleton compliance DON'T MODIFY! (Unless you know wtf you're doing)

+ (WWOApiManager *)sharedManager
{
  if (sharedManager == nil) {
    sharedManager = [[super allocWithZone:NULL] init];
  }
  return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
  return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (id)retain
{
  return self;
}

- (NSUInteger)retainCount
{
  return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
  //do nothing
}

- (id)autorelease
{
  return self;
}

#pragma mark - api implementation
- (void) fetchMessages
{
  //TODO: add user token etc.
  if (!self.messagesRequest) {
    NSURL *url = kWWOUrl(@"messages.json");
    self.messagesRequest = [ASIHTTPRequest requestWithURL:url];
    self.messagesRequest.delegate = self;
    self.messagesRequest.timeOutSeconds = 2 * 60;
    [self.messagesRequest startAsynchronous];
  }
}

- (void) fetchNearbyUsers
{
    if (!self.nearbyUsersRequest) {
        NSURL *url = kWWOUrl(@"nearby.json");
        self.nearbyUsersRequest = [ASIHTTPRequest requestWithURL: url];
        self.nearbyUsersRequest.delegate = self;
        [self.nearbyUsersRequest startAsynchronous];
    }
}



#pragma mark - request response handling
- (void)requestFinished:(ASIHTTPRequest *)request
{
  //NSLog(@"%@", request.responseString);
  if (request == self.messagesRequest) {
    NSString *jsonString = self.messagesRequest.responseString;
    NSDictionary *responseDict = [jsonString objectFromJSONString];
    int status = [[responseDict objectForKey:@"status"] intValue];
    
    if (status == 0) {
        [Notification send:@"FailedToFetchMessages"];
    }
    else {
      NSArray *messageDicts = [responseDict objectForKey:@"messages"];
      NSMutableArray *messages = [NSMutableArray array];
      for (NSDictionary *messageDict in messageDicts) {
        WWOMessage *msg = [[[WWOMessage alloc] initWithDictionary:messageDict] autorelease];
        [messages addObject: msg];
      }
        [Notification send:@"DidFetchMessages" withData:messages];
    }
    self.messagesRequest = nil;
  }
  else if (request == self.nearbyUsersRequest) {
      //todo: status
      NSString *jsonString = self.nearbyUsersRequest.responseString;
      NSDictionary *responseDict = [jsonString objectFromJSONString];
      //int status = [[responseDict objectForKey:@"status"] intValue];
      
      NSArray *userDicts = [responseDict objectForKey:@"users"];
      NSMutableArray *users = [NSMutableArray array];
      for (NSDictionary *userDict in userDicts) {
          WWOUser *user = [[[WWOUser alloc] initWithDictionary:userDict] autorelease];
          [users addObject: user];
      }
      [Notification send:@"DidFetchNearbyUsers" withData:users];
      self.messagesRequest = nil;
  }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
  if (request == self.messagesRequest) {
      self.messagesRequest = nil;
  }
  else if (request == self.nearbyUsersRequest) {
      self.nearbyUsersRequest = nil;
  }
}


@end
