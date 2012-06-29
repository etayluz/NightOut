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
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequestDelegate.h"

#define kWWOBaseURL     @"http://nightapi.pagodabox.com/api/v1"
#define kWWOUrl(path)   [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kWWOBaseURL, (path)]];
#define appID           @"183435348401103"

@interface ServerInterface : NSObject <ASIHTTPRequestDelegate, FBSessionDelegate>

+ (ServerInterface *)sharedManager;

- (void) fetchMessages;
- (void) fetchNeighborhood;
- (void) fetchUserByID: (NSInteger) userID;
- (void) sendLocationToServer:(CLLocation *) location;
- (void) sendLocationToServerInBackground:(CLLocation *)location;

- (BOOL) isUserLoggedIn;
- (void) showLoginPrompt;
- (void) logout;
- (BOOL) handleOpenUrl:(NSURL *)url;

@property (retain, nonatomic) Facebook *facebook;

@end
