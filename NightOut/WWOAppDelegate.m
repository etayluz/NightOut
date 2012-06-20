//
//  WWOAppDelegate.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "Notification.h"
#import "WWOServerInterface.h"
#import "WWOAppDelegate.h"
#import "WWOMessagesViewController.h"
#import "WWONearbyViewController.h"
#import "WWOLoginViewController.h"

@implementation WWOAppDelegate

@synthesize window;
@synthesize tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /* Register UserDidLogin notification with Notification Center */
    [Notification registerNotification:@"UserDidLogin" target:self selector:@selector(userDidLogin)];

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    [self showLoginViewIfUserIsLoggedOut];
    
    return YES;
}


- (void)showLoginViewIfUserIsLoggedOut
{
    if (![[WWOServerInterface sharedManager] isUserLoggedIn]) {
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


- (void) createAndAddTabs
{
    if (self.tabBarController.childViewControllers.count > 0)
        return;
    
    UIViewController *messagesViewController = [[[WWOMessagesViewController alloc] init] autorelease];
    UIViewController *nearbyViewController = [[[WWONearbyViewController alloc] init] autorelease];
    
    UINavigationController *messagesNavController = [[[UINavigationController alloc] initWithRootViewController:messagesViewController] autorelease];
    UINavigationController *nearbyNavController = [[[UINavigationController alloc] initWithRootViewController:nearbyViewController] autorelease];

    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             nearbyNavController, messagesNavController, nil];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


// Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[WWOServerInterface sharedManager] handleOpenUrl:url]; 
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[WWOServerInterface sharedManager] handleOpenUrl:url]; 
}


- (void)dealloc
{
    [Notification unregisterNotification:@"UserDidLogin" target:self];
    
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
