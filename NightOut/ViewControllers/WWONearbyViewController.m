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

#import "WWONearbyGridViewCell.h"

#import "WWOApiManager.h"
#import "WWOUser.h"

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
    
    [Notification off:@"DidFetchNearbyUsers" target:self];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *headerImage = [UIImage imageNamed:@"header.png"];
    
    
    [Notification on:@"DidFetchNearbyUsers" target:self selector:@selector(loadedNearbyUsers:)];
    [[WWOApiManager sharedManager] fetchNearbyUsers];
    
    
    [self.gridView setGridHeaderView: [[[UIImageView alloc] initWithImage:headerImage] autorelease]];
    
    [self.gridView reloadData];
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
		cell = [[[WWONearbyGridViewCell alloc] initWithFrame:CGRectMake(0, 0, 94, 140)
									  reuseIdentifier:nearbyFriendCellIdentifier] autorelease];   
    }
    
    WWOUser *user = [self.users objectAtIndex:index];
    [cell updateFromUser:user];
    
    return cell;
}

#pragma mark - Notifications
- (void)loadedNearbyUsers:(NSNotification *) notification
{
    NSLog(@"loaded nearby users");
    self.users = [notification.userInfo objectForKey:@"data"];
    [self.gridView reloadData];
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

- (void) showUserProfile:(WWOUser *)user
{
    WWOProfileViewController *profileVC = [[[WWOProfileViewController alloc] init] autorelease];
    [self.navigationController pushViewController:profileVC animated:YES];
    [profileVC updateFromUser:user];
}

@end
