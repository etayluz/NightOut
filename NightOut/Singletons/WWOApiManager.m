//
//  WWOApiManager.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "WWOApiManager.h"
#import "JSONKit.h"
#import "WWOMessage.h"

@interface WWOApiManager ()

@property (nonatomic, retain) ASIHTTPRequest *messagesRequest;

@end

static WWOApiManager *sharedManager = nil;

@implementation WWOApiManager
@synthesize messagesRequest;

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
    NSURL * url = kWWOUrl(@"messages.json");
    self.messagesRequest = [ASIHTTPRequest requestWithURL:url];
    self.messagesRequest.delegate = self;
    self.messagesRequest.timeOutSeconds = 2 * 60;
    [self.messagesRequest startSynchronous];
  }
}

#pragma mark - request response handling
- (void)requestFinished:(ASIHTTPRequest *)request
{
  NSLog(@"%@", request.responseString);
  if (request == self.messagesRequest) {
    NSString *jsonString = self.messagesRequest.responseString;
    NSDictionary *responseDict = [jsonString objectFromJSONString];
    int status = [[responseDict objectForKey:@"status"] intValue];
    
    if (status == 0) {
      [self raiseEvent:WWOApiManagerFailedToFetchMessagesNotification];
    }
    else {
      NSArray *messageDicts = [responseDict objectForKey:@"messages"];
      NSMutableArray *messages = [NSMutableArray array];
      for (NSDictionary *messageDict in messageDicts) {
        WWOMessage *msg = [[[WWOMessage alloc] initWithDictionary:messageDict] autorelease];
        [messages addObject: msg];
      }
      [self raiseEvent:WWOApiManagerDidFetchMessagesNotification withData:messages];
    }
  }
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

- (void)requestFailed:(ASIHTTPRequest *)request
{
  if (request == self.messagesRequest) {
    
  }
}


@end
