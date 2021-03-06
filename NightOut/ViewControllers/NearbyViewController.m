//
//  WWONearbyViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "Notification.h"

#import "NearbyViewController.h"
#import "ProfileViewController.h"
#import "SettingsViewController.h"
#import "ConversationsViewController.h"

#import "NearbyGridViewCell.h"
#import "ServerInterface.h"
#import "User.h"
#import "Neighborhood.h"

#import "AQGridView.h"
#import "NeighborhoodHeaderView.h"

@interface NearbyViewController ()
@property (nonatomic, retain) Neighborhood *neighborhood;
@end

@implementation NearbyViewController

@synthesize neighborhood;
@synthesize gridView;
@synthesize headerView;
@synthesize neighborhoodLabel, coordinatesLabel;
@synthesize fetchNeighborhoodRequest;
@synthesize updateTimer;
@synthesize header;

- (void) dealloc
{
    [super dealloc];
    
    self.neighborhood = nil;
    self.gridView = nil;
    self.headerView = nil;
    self.neighborhoodLabel = nil;
    self.coordinatesLabel = nil;
    
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    
    [Notification unregisterNotification:@"UserDidChangeLocation" target:self];
    [Notification unregisterNotification:@"DidUpdateLocation" target:self];
    [Notification unregisterNotification:@"ApplicationDidBecomeActive" target:self];
    [Notification unregisterNotification:@"ApplicationWillResignActive" target:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self addMessagesButton];
    [self addFiltersButton];

    [Notification registerNotification:@"UserDidChangeLocation" target:self selector:@selector(userDidChangeLocation:)];
    [Notification registerNotification:@"DidUpdateLocation" target:self selector:@selector(didUpdateLocation)];
    [Notification registerNotification:@"ApplicationDidBecomeActive" target:self selector:@selector(applicationDidBecomeActive)];
    [Notification registerNotification:@"ApplicationWillResignActive" target:self selector:@selector(applicationWillResignActive)];
    
    self.fetchNeighborhoodRequest = [[[FetchNeighborhoodRequest alloc] init] autorelease];
    self.fetchNeighborhoodRequest.delegate = self;
    [self.fetchNeighborhoodRequest send];

    self.gridView = [[[AQGridView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    self.gridView.showsVerticalScrollIndicator = NO;
    self.gridView.backgroundColor = [UIColor colorWithRed:0.929 green:0.933 blue:0.863 alpha:1];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    [self.gridView setContentSizeGrowsToFillBounds:TRUE];

    [self.view addSubview:gridView];
    
    self.header = [[[NeighborhoodHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 156)] autorelease];
    self.gridView.gridHeaderView = self.header;
    [self.gridView reloadData];

    UIImageView *neighborhoodLabelBackground = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Ribbon.png"]] autorelease];
    neighborhoodLabelBackground.frame = CGRectMake(0, 2, 130, 32.5);
    neighborhoodLabel.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:neighborhoodLabelBackground];
    
    self.neighborhoodLabel = [[[UILabel alloc] initWithFrame:CGRectMake(25, 1.5, 120, 30)] autorelease];
    self.neighborhoodLabel.font  =  [UIFont fontWithName:@"Myriad" size:13];
    self.neighborhoodLabel.textColor = [UIColor whiteColor];
    self.neighborhoodLabel.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:self.neighborhoodLabel];
    
    self.coordinatesLabel = [[[UILabel alloc] initWithFrame:CGRectMake(175, 0, 120, 30)] autorelease];
    self.coordinatesLabel.font              = [UIFont boldSystemFontOfSize:10];
    self.coordinatesLabel.backgroundColor = [UIColor whiteColor];
    self.coordinatesLabel.hidden = YES;
    [self.view addSubview:self.coordinatesLabel];
    
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] 
                                   initWithTitle: @"Nearby" 
                                   style:UIBarButtonItemStylePlain 
                                   target:self  
                                   action:@selector(myBackAction:)] autorelease];
    self.navigationItem.backBarButtonItem = backButton;
    
    [self startUpdatingAtRegularIntervals];
    
}

- (void) startUpdatingAtRegularIntervals
{
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:NEARBY_VIEW_REFRESH_INTERVAL_IN_SECONDS target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

- (void) stopUpdatingAtRegularIntervals
{
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

- (void) tick:(NSTimer *)timer
{
    NSLog(@"tick");
    [self.fetchNeighborhoodRequest send];
}
     
- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(100, 150) );
}

- (void)addMessagesButton
{
    UIBarButtonItem *messagesButton = [[[UIBarButtonItem alloc] initWithTitle:@"Messages" style:UIBarButtonItemStylePlain target:self action:@selector(messagesButtonWasClicked)] autorelease];
    
    self.navigationItem.rightBarButtonItem = messagesButton;
}

- (void)addFiltersButton
{
    UIBarButtonItem *filtersButton = [[[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStylePlain target:self action:@selector(filtersButtonWasClicked)] autorelease];
    
    self.navigationItem.leftBarButtonItem = filtersButton;

}

- (void)messagesButtonWasClicked
{
    [self showMessages];
}

- (void)filtersButtonWasClicked
{
    [self showFilters];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.neighborhood = nil;
    self.gridView = nil;
    self.headerView = nil;
    self.neighborhoodLabel = nil;
    self.coordinatesLabel = nil;
    
    [Notification unregisterNotification:@"DidUpdateLocation" target:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark data source implementation

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return self.neighborhood.users.count;
}

- (AQGridViewCell *) gridView: (AQGridView *) _gridView cellForItemAtIndex: (NSUInteger) index
{    
    static NSString *nearbyFriendCellIdentifier = @"NearbyFriendCellIdentifier";
    NearbyGridViewCell *cell = nil;
    cell = (NearbyGridViewCell *)[_gridView dequeueReusableCellWithIdentifier:nearbyFriendCellIdentifier];
    
    if (!cell) {
		cell = [[[NearbyGridViewCell alloc] initWithFrame:CGRectMake(0, 0, 100, 150)
									  reuseIdentifier:nearbyFriendCellIdentifier] autorelease];   
    }
    
    User *user = [self.neighborhood.users objectAtIndex:index];
    [cell updateFromUser:user];
    
    return cell;
}

- (void) didFetchNeighborhood:(Neighborhood *)n;
{
    self.neighborhood = n;
    self.neighborhoodLabel.text = self.neighborhood.name;
    [self.gridView reloadData];
    
    [self.header updateWithUser:n.currentUser];
}

#pragma mark - Notifications

- (void) didUpdateLocation
{
    [self.fetchNeighborhoodRequest send];
}

- (void) applicationDidBecomeActive
{
    [self.fetchNeighborhoodRequest send];
    
    [self startUpdatingAtRegularIntervals];
}
     
- (void) applicationWillResignActive
{
    [self stopUpdatingAtRegularIntervals];
}

- (void)userDidChangeLocation:(NSNotification *) notification
{
    CLLocation *location = [notification.userInfo objectForKey:@"data"];
    NSString *coordinates = [NSString stringWithFormat:@"%f, %f", location.coordinate.latitude, location.coordinate.longitude];
    self.coordinatesLabel.text = coordinates;
}

- (NSUInteger) gridView: (AQGridView *) gridView willSelectItemAtIndex: (NSUInteger) index
{
    User *selectedUser = [self.neighborhood.users objectAtIndex:index];
    [self userWasSelected:selectedUser];
    return index;
}

- (void) userWasSelected:(User *)user
{
    [self showUserProfile:user];
}

- (void)showUserProfile:(User *)user
{
    ProfileViewController *profileVC = [[[ProfileViewController alloc] init] autorelease];
    profileVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    profileVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:profileVC animated:YES];
    
    [profileVC loadFromUserID:user.OID];
}

- (void) showFilters
{
    SettingsViewController *filtersVC = [[[SettingsViewController alloc] init] autorelease];
    [self.navigationController pushViewController:filtersVC animated:YES];
}

- (void)showMessages
{
    ConversationsViewController *conversationsVC = [[[ConversationsViewController alloc] init] autorelease];
    conversationsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationsVC animated:YES];
}

@end
