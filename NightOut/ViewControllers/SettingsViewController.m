//
//  WWOFiltersViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/20/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "SettingsViewController.h"
#import "ServerInterface.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize locationManager;
@synthesize longitudeLabel, latitudeLabel;
@synthesize timeLabel;
@synthesize updateLocationButton;

- (IBAction)userDidClickLogoutButton:(id)sender
{
    [[ServerInterface sharedManager] logout];
}

- (IBAction)userDidClickUpdateLocationButton:(id)sender;
{
    NSLog(@"user did click update location button");
    [self.locationManager startUpdatingLocation];
}

- (void) refreshLocationLabelsWithLatitude: (CLLocationDegrees) aLatitude andLongitdue: (CLLocationDegrees) aLongitude
{
    NSString *latitude = [NSString stringWithFormat:@"%f", aLatitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", aLongitude];
    
    self.latitudeLabel.text = latitude;
    self.longitudeLabel.text = longitude;
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    self.timeLabel.text = [formatter stringFromDate:[NSDate date]];
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
    [self refreshLocationLabelsWithLatitude:newLocation.coordinate.latitude andLongitdue:newLocation.coordinate.longitude];
    [self.locationManager stopUpdatingLocation];
    
    [[ServerInterface sharedManager] updateLocationWithLatitude:newLocation.coordinate.latitude andLongitdue:newLocation.coordinate.longitude];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Custom initialization
    self.view.backgroundColor = [UIColor orangeColor];
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
        
    /* Latitude/Longitude Labels */
    self.latitudeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)] autorelease];
    [self.view addSubview:self.latitudeLabel];
    
    self.longitudeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 50, 300, 50)] autorelease];
    [self.view addSubview:self.longitudeLabel];
    
    self.timeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 100, 300, 50)] autorelease];
    [self.view addSubview:self.timeLabel];
    
    /* Update Location Button */
    self.updateLocationButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [self.updateLocationButton addTarget:self action:@selector(userDidClickUpdateLocationButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.updateLocationButton setTitle: @"Update Location" forState: UIControlStateNormal];
    self.updateLocationButton.frame = CGRectMake(5, 200, 200, 100);    
    [self.view addSubview:self.updateLocationButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.locationManager = nil;
    self.latitudeLabel = nil;
    self.longitudeLabel = nil;
    self.timeLabel = nil;
    
    self.updateLocationButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    [super dealloc];
}

@end
