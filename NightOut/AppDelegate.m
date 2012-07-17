//
//  WWOAppDelegate.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "Notification.h"
#import "ServerInterface.h"
#import "AppDelegate.h"

#import "GPS.h"

#import "NearbyViewController.h"
#import "WWOLoginViewController.h"
#import "SmileMainViewController.h"
#import "ProfileViewController.h"

#import "UAirship.h"
#import "UAPush.h"

#import "TestFlight.h"

@implementation AppDelegate

@synthesize window;
@synthesize tabBarController;

@synthesize updateLocationRequest, registerPushTokenRequest;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

/*Test Flight*/
    [TestFlight takeOff:@"caef746a9510d49aa3c2396f81215e0e_MTEwNDYzMjAxMi0wNy0xNSAyMDoxMTo0NC43MDg1NzY"];

    
    NSLog(@"app did finish launching w options");
    /* Register UserDidLogin notification with Notification Center */
    [Notification registerNotification:@"UserDidLogin" target:self selector:@selector(userDidLogin)];
    
    [Notification registerNotification:@"UserDidChangeLocation" target:self selector:@selector(userDidChangeLocation:)];

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    [self showLoginViewIfUserIsLoggedOut];
    
    [GPS main].locationManager.delegate = self;
    [[GPS main].locationManager startUpdatingLocation];
    
    self.updateLocationRequest = [[[UpdateLocationRequest alloc] init] autorelease];
    self.registerPushTokenRequest = [[[RegisterPushTokenRequest alloc] init] autorelease];
        
    [self setupPushNotifications];
    
    return YES;
}

- (void) setupPushNotifications
{
    //Init Airship launch options
    NSMutableDictionary *takeOffOptions = [[[NSMutableDictionary alloc] init] autorelease];
    
    // Create Airship singleton that's used to talk to Urban Airhship servers.
    // Please populate AirshipConfig.plist with your info from http://go.urbanairship.com
    [UAirship takeOff:takeOffOptions];
    
    //zero badge on startup
    [[UAPush shared] resetBadge];
    
    [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeSound |
                                                         UIRemoteNotificationTypeAlert)];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {    
    
    NSString *pushToken = [[[[deviceToken description]
                                stringByReplacingOccurrencesOfString: @"<" withString: @""] 
                               stringByReplacingOccurrencesOfString: @">" withString: @""] 
                              stringByReplacingOccurrencesOfString: @" " withString: @""];

    NSLog(@"APN token = %@", pushToken);

    // Updates the device token and registers the token with UA
    [[UAPush shared] registerDeviceToken:deviceToken];
    
    if ([ServerInterface sharedManager].isUserLoggedIn)
        [self.registerPushTokenRequest send:deviceToken];
    
    /*
     * Some example cases where user notification may be warranted
     *
     * This code will alert users who try to enable notifications
     * from the settings screen, but cannot do so because
     * notications are disabled in some capacity through the settings
     * app.
     * 
     */
    
    /*
     
     //Do something when notifications are disabled altogther
     if ([application enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
     UALOG(@"iOS Registered a device token, but nothing is enabled!");
     
     //only alert if this is the first registration, or if push has just been
     //re-enabled
     if ([UAirship shared].deviceToken != nil) { //already been set this session
     NSString* okStr = @"OK";
     NSString* errorMessage =
     @"Unable to turn on notifications. Use the \"Settings\" app to enable notifications.";
     NSString *errorTitle = @"Error";
     UIAlertView *someError = [[UIAlertView alloc] initWithTitle:errorTitle
     message:errorMessage
     delegate:nil
     cancelButtonTitle:okStr
     otherButtonTitles:nil];
     
     [someError show];
     [someError release];
     }
     
     //Do something when some notification types are disabled
     } else if ([application enabledRemoteNotificationTypes] != [UAPush shared].notificationTypes) {
     
     UALOG(@"Failed to register a device token with the requested services. Your notifications may be turned off.");
     
     //only alert if this is the first registration, or if push has just been
     //re-enabled
     if ([UAirship shared].deviceToken != nil) { //already been set this session
     
     UIRemoteNotificationType disabledTypes = [application enabledRemoteNotificationTypes] ^ [UAPush shared].notificationTypes;
     
     
     
     NSString* okStr = @"OK";
     NSString* errorMessage = [NSString stringWithFormat:@"Unable to turn on %@. Use the \"Settings\" app to enable these notifications.", [UAPush pushTypeString:disabledTypes]];
     NSString *errorTitle = @"Error";
     UIAlertView *someError = [[UIAlertView alloc] initWithTitle:errorTitle
     message:errorMessage
     delegate:nil
     cancelButtonTitle:okStr
     otherButtonTitles:nil];
     
     [someError show];
     [someError release];
     }
     }
     
     */
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    UALOG(@"Failed To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Received remote notification: %@", userInfo);
    
    // Get application state for iOS4.x+ devices, otherwise assume active
    UIApplicationState appState = UIApplicationStateActive;
    if ([application respondsToSelector:@selector(applicationState)]) {
        appState = application.applicationState;
    }
    
    if ([userInfo objectForKey:@"event"] != nil) {
        NSDictionary *event = [userInfo objectForKey:@"event"];
        NSString *eventName = [event objectForKey:@"name"];
        NSLog(@"[SERVERSIDE EVENT] %@ :: %@ ", eventName, event);
        [Notification send:eventName withData:event];
    }
    
    [[UAPush shared] handleNotification:userInfo applicationState:appState];
    [[UAPush shared] resetBadge]; // zero badge after push received
}

- (void) createAndAddTabs
{
    if (self.tabBarController.childViewControllers.count > 0)
        return;
    
    /* Nearby Page */
    NearbyViewController *nearbyViewController = [[[NearbyViewController alloc] init] autorelease];
    UINavigationController *nearbyNavController = [[[UINavigationController alloc] initWithRootViewController:nearbyViewController] autorelease];
    nearbyNavController.title = @"Nearby";
    nearbyNavController.tabBarItem.image = [UIImage imageNamed:@"nearby_icon.png"];

    /* Smile Page */
    SmileMainViewController *smileMainViewController = [[[SmileMainViewController alloc] init] autorelease];
    UINavigationController *smileMainNavController = [[[UINavigationController alloc] initWithRootViewController:smileMainViewController] autorelease];
    smileMainNavController.title = @"Smiles";
    smileMainNavController.tabBarItem.image = [UIImage imageNamed:@"smiley_icon.png"];
    
    /* Profile Page */
    ProfileViewController *profileViewController = [[[ProfileViewController alloc] init] autorelease];
    
    profileViewController.hideSmileAndMessageButtons = YES;
    profileViewController.hideMutualFriends = YES;
    profileViewController.fetchCurrentUserOnLoad = YES;
    profileViewController.autoUpdateTitle = NO;
    
    UINavigationController *profileNavController = [[[UINavigationController alloc] initWithRootViewController:profileViewController] autorelease];
    profileNavController.title = @"Profile";
    profileNavController.tabBarItem.image = [UIImage imageNamed:@"profile_icon.png"];
    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             nearbyNavController, smileMainNavController, profileNavController, nil];

}

- (void)showLoginViewIfUserIsLoggedOut
{
    if (![[ServerInterface sharedManager] isUserLoggedIn]) {
        WWOLoginViewController *loginViewController = [[[WWOLoginViewController alloc] init] autorelease];
        [self.tabBarController presentModalViewController:loginViewController animated:NO];
    }
    else {
        [Notification send:@"UserDidLogin"];
    }
}


- (void)userDidLogin
{
    [self createAndAddTabs];
    [self.tabBarController dismissModalViewControllerAnimated:YES];
}

- (void)userDidChangeLocation:(NSNotification *) notification
{
    CLLocation *location = [notification.userInfo objectForKey:@"data"];
        
    if ([self appIsInBackground])
    {
        [self.updateLocationRequest sendInBackground:location];
    }
    else
    {
        [self.updateLocationRequest send:location];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
    [Notification send:@"ApplicationWillResignActive"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"applicationDidEnterBackground");
    [[[GPS main] locationManager] startMonitoringSignificantLocationChanges];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"applicationDidBecomeActive");
    
    [[UAPush shared] resetBadge]; //zero badge when resuming from background (iOS 4+)
    [[[GPS main] locationManager] startMonitoringSignificantLocationChanges];
    
    [Notification send:@"ApplicationDidBecomeActive"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");
    
    [UAirship land];
}

- (BOOL) appIsInForeground
{
    return ![self appIsInBackground];
}

- (BOOL) appIsInBackground
{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



/*
 *  locationManager:didUpdateToLocation:fromLocation:
 *  
 *  Discussion:
 *    Invoked when a new location is available. oldLocation may be nil if there is no previous location
 *    available.
 */
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (newLocation.coordinate.latitude == oldLocation.coordinate.latitude
        && newLocation.coordinate.longitude == oldLocation.coordinate.longitude)
        return;
    
    [Notification send:@"UserDidChangeLocation" withData:newLocation];
}

// Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[ServerInterface sharedManager] handleOpenUrl:url]; 
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[ServerInterface sharedManager] handleOpenUrl:url]; 
}


- (void)dealloc
{
    [Notification unregisterNotification:@"UserDidLogin" target:self];
    [Notification unregisterNotification:@"UserDidChangeLocation" target:self];

    self.window = nil;
    self.tabBarController = nil;
    
    [super dealloc];
}


/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
