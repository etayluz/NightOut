//
//  UpdateLocationRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/3/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerPostRequest.h"
#import <CoreLocation/CoreLocation.h>

@interface UpdateLocationRequest : ServerPostRequest

- (void) send:(CLLocation *) location;
- (void) sendInBackground:(CLLocation *)location;

@end
