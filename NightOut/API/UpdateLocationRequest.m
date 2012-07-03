//
//  UpdateLocationRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/3/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "UpdateLocationRequest.h"
#import <CoreLocation/CoreLocation.h>

#import "Notification.h"

@interface UpdateLocationRequest()

@property (assign) UIBackgroundTaskIdentifier backgroundTask;

@end

@implementation UpdateLocationRequest
@synthesize backgroundTask;

- (void) send:(CLLocation *) location
{
    NSLog(@"WWWW updateLocationRequest");
    NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    
    NSLog(@"WWWW updating latitude = %@, longitude = %@", latitude, longitude);
    
    NSString *url = @"http://wwoapp.herokuapp.com/api/v1/location";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.accessToken, @"token",
                            latitude, @"latitude", longitude, @"longitude", nil];
    
    [self sendToUrl:url withParams:params];
}

-(void) sendInBackground:(CLLocation *)location
{
    NSLog(@" WWW sendLocationToServerInBackground");
    
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:
                   ^{
                       [[UIApplication sharedApplication] endBackgroundTask: self.backgroundTask];
                   }];
    
    [self send:location];
    
    if (self.backgroundTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        backgroundTask = UIBackgroundTaskInvalid;
    }
}

- (void) didFetchJson:(NSDictionary *)json
{
    [Notification send:@"DidUpdateLocation"];
}

@end
