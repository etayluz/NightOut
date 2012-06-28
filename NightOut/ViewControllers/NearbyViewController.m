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

@interface NearbyViewController ()
@property (nonatomic, retain) Neighborhood *neighborhood;
@end

@implementation NearbyViewController

@synthesize neighborhood;
@synthesize gridView;
@synthesize headerView;
@synthesize neighborhoodLabel;

- (void) dealloc
{
    self.neighborhood = nil;
    self.gridView = nil;
    self.headerView = nil;
    
    [Notification unregisterNotification:@"DidFetchNeighborhood" target:self];
    [Notification unregisterNotification:@"DidUpdateLocation" target:self];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *headerImage = [UIImage imageNamed:@"header.png"];

    [self addMessagesButton];
    [self addFiltersButton];

    [Notification registerNotification:@"DidFetchNeighborhood" target:self selector:@selector(loadedNeighborhood:)];
    [Notification registerNotification:@"DidUpdateLocation" target:self selector:@selector(didUpdateLocation)];
    
    [[ServerInterface sharedManager] fetchNeighborhood];

    self.gridView = [[[AQGridView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    self.gridView.showsVerticalScrollIndicator = NO;
    self.gridView.backgroundColor = [UIColor lightGrayColor];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    [self.gridView setContentSizeGrowsToFillBounds:TRUE];

    [self.view addSubview:gridView];
    [self.gridView setGridHeaderView: [[[UIImageView alloc] initWithImage:headerImage] autorelease]];
    [self.gridView reloadData];

    self.neighborhoodLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)] autorelease];
    self.neighborhoodLabel.backgroundColor = [UIColor yellowColor];
    self.neighborhoodLabel.text = @"woo";
    [self.view addSubview:self.neighborhoodLabel];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Nearby" 
                                   style:UIBarButtonItemStylePlain 
                                   target:self 
                                   action:@selector(myBackAction:)];
    self.navigationItem.backBarButtonItem = backButton;
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
    // Release any retained subviews of the main view.
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

#pragma mark - Notifications
- (void) loadedNeighborhood:(NSNotification *) notification
{
    NSLog(@"loaded neighborhood");
    self.neighborhood = [notification.userInfo objectForKey:@"data"];
    NSLog(@"name = %@", neighborhood.name);
    self.neighborhoodLabel.text = self.neighborhood.name;
    [self.gridView reloadData];
    
    /* UNCOMMENT TO SKIP TO PROFILE PAGE */
    //[self gridView:self.gridView willSelectItemAtIndex:1];
    
    /* UNCOMMENT TO SKIP TO MAIN SMILES PAGE */
    self.tabBarController.selectedIndex = 1;
    
    /* UNCOMMENT TO SKIP TO FILTERS SMILES PAGE */
    //[self showFilters];
}

- (void) didUpdateLocation
{
    [[ServerInterface sharedManager] fetchNeighborhood];
}

- (NSUInteger) gridView: (AQGridView *) gridView willSelectItemAtIndex: (NSUInteger) index
{
    User *selectedUser = [self.neighborhood.users objectAtIndex:index];
    [self userWasSelected:selectedUser];
    return index;
}

- (void) userWasSelected:(User *)user
{
    NSLog(@"selected %@", user.name);
    [self showUserProfile:user];
}

- (void)showUserProfile:(User *)user
{
    ProfileViewController *profileVC = [[[ProfileViewController alloc] init] autorelease];
    profileVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profileVC animated:YES];
    
    [profileVC updateFromUserID:user.userID];
}


- (void) showFilters
{
    SettingsViewController *filtersVC = [[[SettingsViewController alloc] init] autorelease];
    [self.navigationController pushViewController:filtersVC animated:YES];
}



- (void)showMessages
{
    ConversationsViewController *messagesVC = [[[ConversationsViewController alloc] init] autorelease];
    [self.navigationController pushViewController:messagesVC animated:YES];
}


@end
