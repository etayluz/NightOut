//
//  WWOApiManager.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "WWOServerInterface.h"
#import "JSONKit.h"
#import "Notification.h"

#import "WWOConversation.h"
#import "WWOUser.h"

#import "WWONearbyUsersRequest.h"

@interface WWOServerInterface ()

@property (nonatomic, retain) ASIHTTPRequest *messagesRequest;
@property (nonatomic, retain) ASIHTTPRequest *nearbyUsersRequest;

@end

static WWOServerInterface *sharedManager = nil;

@implementation WWOServerInterface
@synthesize messagesRequest, nearbyUsersRequest, facebook;

#pragma mark - Singleton compliance DON'T MODIFY! (Unless you know wtf you're doing)

+ (WWOServerInterface *)sharedManager
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
    /*@property (retain) NSNumber *userID;
     @property (retain) NSString *name;
     @property (retain) NSString *network;
     @property (retain) NSNumber *age;
     @property (retain) NSNumber *friends;
     @property (retain) NSString *thumb;
     
     @property (retain) NSString *hometown;
     @property (retain) NSString *currentCity;
     @property (retain) NSString *college;
     @property (retain) NSString *interestedIn;
     @property (retain) NSString *relationshipStatus;
*/
    
    WWOUser *user = [[[WWOUser alloc] init] autorelease];
    user.name = @"Wowo L.";
    user.age = [NSNumber numberWithInt:27];
    user.network = @"Santa Claus";
    user.friends = [NSNumber numberWithInt:9382];
    user.thumb = @"http://nightapi.pagodabox.com/images/etay.png";
    user.hometown = @"Tel Aviv";
    user.currentCity = @"New York";
    user.college = @"Hogwarts";
    user.interestedIn = @"women";
    user.relationshipStatus = @"single";
    
    [Notification send:@"DidFetchUser" withData:user];
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
                WWOConversation *msg = [[[WWOConversation alloc] initWithDictionary:messageDict] autorelease];
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
            WWOUser *user = [[[WWOUser alloc] initWithDictionary:userDict] autorelease];
            [users addObject: user];
        }
        [Notification send:@"DidFetchNearbyUsers" withData:users];
        self.messagesRequest = nil;
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


- (void) showLoginPrompt
{
    [facebook authorize:nil];
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
