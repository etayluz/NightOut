//
//  GPS.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/28/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "GPS.h"

@implementation GPS

@synthesize locationManager;

+ (GPS *) main
{
    static GPS *main = nil;
    
    if (!main)
        main = [[self alloc] init];
    
    return main;
}

- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;

    return self;
}

@end
