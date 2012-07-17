//
//  WWOApiManager.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerInterface.h"
#import "Notification.h"

static ServerInterface *sharedManager = nil;

@implementation ServerInterface

@synthesize facebook;

#pragma mark - Singleton compliance DON'T MODIFY! (Unless you know wtf you're doing)

+ (ServerInterface *)sharedManager
{
    if (sharedManager == nil) {
        sharedManager = [[ServerInterface alloc] init];
    }
    
    return sharedManager;
}

- (id) init
{
    self = [super init];
    if (self) {
        [self initFacebookObject];
    }
    
    return self;
}


#pragma mark - api implementation
- (void) fetchMessages
{
}

/*****************************************************************************************/
/* ALL THE CONTENT TO THE END OF THIS FILE SHOULD BE PLACED IN A SEPARATE FACEBOOK CLASS */
/*****************************************************************************************/
#pragma mark facebook auth
- (void) initFacebookObject
{
    // create a facebook instance with the given app id
    facebook = [[Facebook alloc] initWithAppId:appID andDelegate:self];
    // if fb login credentials are already saved away, get them from there
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
}

- (BOOL) isUserLoggedIn
{
    return facebook.isSessionValid;
}

- (void) logout
{
    [facebook logout];
}

- (void) showLoginPrompt
{
    NSArray *permissions = [[[NSArray alloc] initWithObjects:@"user_birthday", @"user_education_history", @"user_hometown", @"user_events", @"user_hometown", @"user_interests", @"user_location", @"user_photos", @"user_relationships", @"user_relationship_details", @"user_work_history", @"email", nil] autorelease];
    
    [facebook authorize:permissions];
}


/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin
{
    NSLog(@"fbDidLogin");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    NSLog(@"fb token = %@", [facebook accessToken]);
    
    [Notification send:@"UserDidLogin"];
}


/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
    NSLog(@"fbDidNotLogin");
}


/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    NSLog(@"fbDidExtendToken");
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{
    NSLog(@"fbDidLogout");
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}


/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated
{
    NSLog(@"fbSessionInvalidated");
}


- (BOOL) handleOpenUrl:(NSURL *)url
{
    return [self.facebook handleOpenURL:url];
}
@end
