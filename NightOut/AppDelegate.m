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

#import "WWOExploreViewController.h"
#import "NearbyViewController.h"
#import "WWOLoginViewController.h"
#import "SmileMainViewController.h"

@implementation AppDelegate

@synthesize window;
@synthesize tabBarController;

// venkats id: c2870baff47f56b53d0e492f5b3de3a2ce7e5269

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
    
    return YES;
}

- (void) createAndAddTabs
{
    if (self.tabBarController.childViewControllers.count > 0)
        return;
    
    UIViewController *exploreViewController = [[[WWOExploreViewController alloc] init] autorelease];
    UIViewController *nearbyViewController = [[[NearbyViewController alloc] init] autorelease];
    UIViewController *smileMainViewController = [[[SmileMainViewController alloc] init] autorelease];
    UINavigationController *exploreNavController = [[[UINavigationController alloc] initWithRootViewController:exploreViewController] autorelease];
    UINavigationController *nearbyNavController = [[[UINavigationController alloc] initWithRootViewController:nearbyViewController] autorelease];
    UINavigationController *smileMainNavController = [[[UINavigationController alloc] initWithRootViewController:smileMainViewController] autorelease];
    
    exploreNavController.title = @"Explore";
    nearbyNavController.title = @"Nearby";
    smileMainNavController.title = @"Smiles";
    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             nearbyNavController, smileMainNavController, exploreNavController, nil];
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
        [[ServerInterface sharedManager] sendLocationToServerInBackground:location];
    }
    else
    {
        [[ServerInterface sharedManager] sendLocationToServer:location];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
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
    [[[GPS main] locationManager] startMonitoringSignificantLocationChanges];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");
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
    

    
    NSLog(@"UserDidChangeLocation");
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

    [self.window release];
    [self.tabBarController release];
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
