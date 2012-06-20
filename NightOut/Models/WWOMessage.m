//
//  WWOMessage.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "WWOMessage.h"

@implementation WWOMessage

@synthesize name, age, userID, caption, message, network, friends;

- (id) initWithDictionary: (NSDictionary *) dictionary
{
  if (self = [self init]) {
      self.name     = [dictionary objectForKey:@"name"];
      self.age      = [dictionary objectForKey:@"age"];
      self.network  = [dictionary objectForKey:@"networks"];
      self.friends  = [dictionary objectForKey:@"friends"];
      self.userID   = [dictionary objectForKey:@"userID"];
      self.caption  = [dictionary objectForKey:@"caption"];
      self.message  = [dictionary objectForKey:@"message"];
  }
  return self;
}

- (NSMutableDictionary *) toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:self.name forKey:@"name"];
    [dictionary setObject:self.age forKey:@"age"];
    [dictionary setObject:self.userID forKey:@"userID"];
    [dictionary setObject:self.caption forKey:@"caption"];
    [dictionary setObject:self.message forKey:@"message"];
  
    return dictionary;
}

@end
