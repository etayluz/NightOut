//
//  WWOFiltersViewController.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/20/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SettingsViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) UILabel *longitudeLabel;
@property (nonatomic, retain) UILabel *latitudeLabel;
@property (nonatomic, retain) UILabel *timeLabel;

@property (nonatomic, retain) UIButton *updateLocationButton;

- (IBAction)userDidClickLogoutButton:(id)sender;
- (IBAction)userDidClickUpdateLocationButton:(id)sender;

@end
