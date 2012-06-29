//
//  GPS.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/28/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GPS : NSObject

+ (GPS *) main;

@property (nonatomic, retain) CLLocationManager *locationManager;

@end
