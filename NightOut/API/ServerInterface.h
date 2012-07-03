//
//  WWOApiManager.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>

#import <Foundation/Foundation.h>
#import "FBConnect.h"

#define appID           @"183435348401103"

@interface ServerInterface : NSObject <FBSessionDelegate>

+ (ServerInterface *)sharedManager;

- (void) fetchMessages;

- (BOOL) isUserLoggedIn;
- (void) showLoginPrompt;
- (void) logout;
- (BOOL) handleOpenUrl:(NSURL *)url;

@property (retain, nonatomic) Facebook *facebook;

@end
