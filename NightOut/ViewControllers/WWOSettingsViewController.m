//
//  WWOFiltersViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/20/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "WWOSettingsViewController.h"
#import "ServerInterface.h"

@interface WWOSettingsViewController ()

@end

@implementation WWOSettingsViewController

@synthesize locationManager;
@synthesize longitudeLabel, latitudeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
        
        [self refreshLocationLabels];
        
        self.latitudeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)] autorelease];
        self.longitudeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 100, 150, 50)] autorelease];
                
        [self.view addSubview:self.latitudeLabel];
        [self.view addSubview:self.longitudeLabel];
        
        [self refreshLocationLabels];
    }
    return self;
}

- (IBAction)userDidClickLogoutButton:(id)sender
{
    [[ServerInterface sharedManager] logout];
}

- (IBAction)userDidClickUpdateLocationButton:(id)sender;
{
    NSLog(@"user did click update location button");
    [self.locationManager startUpdatingLocation];
}

- (void) refreshLocationLabels
{
    NSString *latitude = [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
    NSLog(@"%@, %@", latitude, longitude);
    
    self.latitudeLabel.text = latitude;
    self.longitudeLabel.text = longitude;
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
    NSLog(@"%@", newLocation.description);
    [self refreshLocationLabels];
    //latitudeLabel = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    //longitudeLabel = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    self.locationManager = nil;
    self.latitudeLabel = nil;
    self.longitudeLabel = nil;
    
    [super dealloc];
}

@end
