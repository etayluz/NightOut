//
//  WWOAppDelegate.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "UpdateLocationRequest.h"
#import "RegisterPushTokenRequest.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic, retain) UpdateLocationRequest *updateLocationRequest;
@property (nonatomic, retain) RegisterPushTokenRequest *registerPushTokenRequest;

@end