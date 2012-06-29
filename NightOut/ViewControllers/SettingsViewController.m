//
//  WWOFiltersViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/20/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "SettingsViewController.h"
#import "ServerInterface.h"
#import "GPS.h"

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Custom initialization
    self.view.backgroundColor = [UIColor orangeColor];
            
    /* Latitude/Longitude Labels */
    self.latitudeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)] autorelease];
    [self.view addSubview:self.latitudeLabel];
    
    self.longitudeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 50, 300, 50)] autorelease];
    [self.view addSubview:self.longitudeLabel];
    
    self.timeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 100, 300, 50)] autorelease];
    [self.view addSubview:self.timeLabel];
    
    /* Update Location Button 
    self.updateLocationButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [self.updateLocationButton addTarget:self action:@selector(userDidClickUpdateLocationButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.updateLocationButton setTitle: @"Update Location" forState: UIControlStateNormal];
    self.updateLocationButton.frame = CGRectMake(5, 200, 200, 100);    
    [self.view addSubview:self.updateLocationButton];*/
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
