//
//  WWOApiManager.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerInterface.h"
#import "JSONKit.h"
#import "Notification.h"

#import "Conversation.h"
#import "User.h"

#import "NearbyUsersRequest.h"


@interface ServerInterface ()

@property (nonatomic, retain) ASIHTTPRequest *messagesRequest;
@property (nonatomic, retain) ASIHTTPRequest *nearbyUsersRequest;
@property (nonatomic, retain) ASIHTTPRequest *profileRequest;
@property (nonatomic, retain) ASIFormDataRequest *updateLocationRequest;

@end

static ServerInterface *sharedManager = nil;

@implementation ServerInterface

@synthesize facebook;
@synthesize messagesRequest, nearbyUsersRequest, profileRequest, updateLocationRequest;

#pragma mark - Singleton compliance DON'T MODIFY! (Unless you know wtf you're doing)

+ (ServerInterface *)sharedManager
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


- (id) init
{
    self = [super init];
    if (self) {
        [self initFacebookObject];
    }
    
    return self;
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
    // denotes an object that cannot be released
    return NSUIntegerMax;  
}


- (oneway void)release
{
    // do nothing
}


- (id)autorelease
{
    return self;
}


#pragma mark - api implementation
- (void) fetchMessages
{
    // TODO: add user token etc.
    if (!self.messagesRequest) {
        NSURL *url = kWWOUrl(@"messages.json");
        self.messagesRequest = [ASIHTTPRequest requestWithURL:url];
        self.messagesRequest.delegate = self;
        self.messagesRequest.timeOutSeconds = 2 * 60;
        [self.messagesRequest startAsynchronous];
    }
}


- (void) fetchNearbyUsers
{
    if (!self.nearbyUsersRequest) {
        NSURL *url = kWWOUrl(@"nearby.json");
        self.nearbyUsersRequest = [ASIHTTPRequest requestWithURL: url];
        self.nearbyUsersRequest.delegate = self;
        [self.nearbyUsersRequest startAsynchronous];
    }
}

- (void) fetchUser
{
    if (!self.profileRequest) {
        NSURL *url = kWWOUrl(@"profile/1.json");
        self.profileRequest = [ASIHTTPRequest requestWithURL:url];
        self.profileRequest.delegate = self;
        [self.profileRequest startAsynchronous];
    }
}

- (void) updateLocationWithLatitude: (CLLocationDegrees) aLatitude andLongitdue: (CLLocationDegrees) aLongitude
{
    if (!self.updateLocationRequest) {
        NSLog(@"updateLocationRequest");
        NSString *latitude = [NSString stringWithFormat:@"%f", aLatitude];
        NSString *longitude = [NSString stringWithFormat:@"%f", aLongitude];
                
        NSLog(@"updating latitude = %@, longitude = %@", latitude, longitude);
        
        NSURL *url = [NSURL URLWithString:@"http://wwoapp.herokuapp.com/api/v1/location"];
        self.updateLocationRequest = [ASIFormDataRequest requestWithURL:url];
        self.updateLocationRequest.delegate = self;
        
        
        [self.updateLocationRequest setPostValue:self.facebook.accessToken forKey:@"token"];
        [self.updateLocationRequest setPostValue:longitude forKey:@"longitude"];
        [self.updateLocationRequest setPostValue:latitude forKey:@"latitude"];
        [self.updateLocationRequest startAsynchronous];
    }
}

#pragma mark - request response handling
- (void)requestFinished:(ASIHTTPRequest *)request
{
    //NSLog(@"%@", request.responseString);
    if (request == self.messagesRequest) {
        NSString *jsonString = self.messagesRequest.responseString;
        NSDictionary *responseDict = [jsonString objectFromJSONString];
        int status = [[responseDict objectForKey:@"status"] intValue];

        if (status == 0) {
            [Notification send:@"FailedToFetchMessages"];
        }
        else {
            NSArray *messageDicts = [responseDict objectForKey:@"messages"];
            NSMutableArray *messages = [NSMutableArray array];
            
            for (NSDictionary *messageDict in messageDicts) {
                Conversation *msg = [[[Conversation alloc] initWithDictionary:messageDict] autorelease];
                [messages addObject: msg];
            }
            
            [Notification send:@"DidFetchMessages" withData:messages];
        }
        self.messagesRequest = nil;
    }
    else if (request == self.nearbyUsersRequest) {
        //todo: status
        NSString *jsonString = self.nearbyUsersRequest.responseString;
        NSDictionary *responseDict = [jsonString objectFromJSONString];
        //int status = [[responseDict objectForKey:@"status"] intValue];
      
        NSArray *userDicts = [responseDict objectForKey:@"users"];
        NSMutableArray *users = [NSMutableArray array];
        for (NSDictionary *userDict in userDicts) {
            User *user = [[[User alloc] initWithDictionary:userDict] autorelease];
            [users addObject: user];
        }
        [Notification send:@"DidFetchNearbyUsers" withData:users];
        self.messagesRequest = nil;
    }
    else if (request == self.profileRequest) {
        NSString *jsonString = self.profileRequest.responseString;
        NSDictionary *responseDict = [jsonString objectFromJSONString];
        NSDictionary *userDict = [responseDict objectForKey:@"user"];
        User *user = [[[User alloc] initWithDictionary:userDict] autorelease];
        
        [Notification send:@"DidFetchUser" withData:user];
        
        self.profileRequest = nil;
    }
    else if (request == self.updateLocationRequest) {
        //NSString *jsonString = self.updateLocationRequest.responseString;
        //NSDictionary *responseDict = [jsonString objectFromJSONString];
        NSLog(@"update location: %@", self.updateLocationRequest.responseString);
        [Notification send:@"DidUpdateLocation"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request == self.messagesRequest) {
        self.messagesRequest = nil;
    }
    else if (request == self.nearbyUsersRequest) {
        self.nearbyUsersRequest = nil;
    }
    else if (request == self.profileRequest) {
        self.profileRequest = nil;
    }
    else if (request == self.updateLocationRequest) {
        self.updateLocationRequest = nil;
    }
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
    return [facebook isSessionValid];
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
