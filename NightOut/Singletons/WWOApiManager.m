//
//  WWOApiManager.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "WWOApiManager.h"

@implementation WWOApiManager
static WWOApiManager *sharedManager = nil;

#pragma mark - Singleton compliance DON'T MODIFY! (Unless you know wtf you're doing)

+ (WWOApiManager*)sharedManager
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



@end
