//
//  WWONearbyViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "Notification.h"

#import "WWONearbyViewController.h"
#import "WWOProfileViewController.h"
#import "WWOSettingsViewController.h"
#import "WWOConversationsViewController.h"

#import "WWONearbyGridViewCell.h"
#import "WWOServerInterface.h"
#import "WWOUser.h"
#import "AQGridView.h"

@interface WWONearbyViewController ()
@property (nonatomic, retain) NSArray *users;
@end

@implementation WWONearbyViewController

@synthesize users;
@synthesize gridView;
@synthesize headerView;

- (void) dealloc
{
    [users release];
    [gridView release];
    [headerView release];
    
    [Notification unregisterNotification:@"DidFetchNearbyUsers" target:self];
    
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

    [Notification registerNotification:@"DidFetchNearbyUsers" target:self selector:@selector(loadedNearbyUsers:)];
    [[WWOServerInterface sharedManager] fetchNearbyUsers];

    self.gridView = [[[AQGridView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    self.gridView.showsVerticalScrollIndicator = NO;
    self.gridView.backgroundColor = [UIColor lightGrayColor];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    [self.gridView setContentSizeGrowsToFillBounds:TRUE];
    //[self.gridView setContentSize:<#(CGSize)#>

    [self.view addSubview:gridView];
    [self.gridView setGridHeaderView: [[[UIImageView alloc] initWithImage:headerImage] autorelease]];
    [self.gridView reloadData];

    
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
    return self.users.count;
}

- (AQGridViewCell *) gridView: (AQGridView *) _gridView cellForItemAtIndex: (NSUInteger) index
{    
    static NSString *nearbyFriendCellIdentifier = @"NearbyFriendCellIdentifier";
    WWONearbyGridViewCell *cell = nil;
    cell = (WWONearbyGridViewCell *)[_gridView dequeueReusableCellWithIdentifier:nearbyFriendCellIdentifier];
    
    if (!cell) {
		cell = [[[WWONearbyGridViewCell alloc] initWithFrame:CGRectMake(0, 0, 100, 150)
									  reuseIdentifier:nearbyFriendCellIdentifier] autorelease];   
    }

    NSLog(@"index = %d", index);

    //cell.backgroundColor = [UIColor purpleColor];

    WWOUser *user = [self.users objectAtIndex:index];
    [cell updateFromUser:user];
    
    return cell;
}

#pragma mark - Notifications
- (void) loadedNearbyUsers:(NSNotification *) notification
{
    NSLog(@"loaded nearby users");
    self.users = [notification.userInfo objectForKey:@"data"];
    [self.gridView reloadData];
    
    /* Comment out to not skip over Nearby Page */
    [self gridView:self.gridView willSelectItemAtIndex:1];
}

- (NSUInteger) gridView: (AQGridView *) gridView willSelectItemAtIndex: (NSUInteger) index
{
    WWOUser *selectedUser = [self.users objectAtIndex:index];
    [self userWasSelected:selectedUser];
    return index;
}

- (void) userWasSelected:(WWOUser *)user
{
    NSLog(@"selected %@", user.name);
    [self showUserProfile:user];
}

- (void)showUserProfile:(WWOUser *)user
{
    WWOProfileViewController *profileVC = [[[WWOProfileViewController alloc] init] autorelease];
    profileVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profileVC animated:YES];
}


- (void) showFilters
{
    WWOSettingsViewController *filtersVC = [[[WWOSettingsViewController alloc] init] autorelease];
    [self.navigationController pushViewController:filtersVC animated:YES];
}



- (void)showMessages
{
    WWOConversationsViewController *messagesVC = [[[WWOConversationsViewController alloc] init] autorelease];
    [self.navigationController pushViewController:messagesVC animated:YES];
}


@end
