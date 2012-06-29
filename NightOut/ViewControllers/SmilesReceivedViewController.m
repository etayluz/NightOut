//
//  WWOSmilesReceivedViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/20/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "SmilesReceivedViewController.h"
#import "Notification.h"
#import "ProfileViewController.h"
#import "SmilesSentViewController.h"
#import "ConversationsViewController.h"
#import "SmilesGridViewCell.h"
#import "ServerInterface.h"
#import "User.h"
#import "AQGridView.h"

@implementation SmilesReceivedViewController

@synthesize gridView, headerView;

- (void) dealloc
{
    [gridView release];
    [headerView release];
    
    [Notification unregisterNotification:@"DidFetchNearbyUsers" target:self];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *headerImage = [UIImage imageNamed:@"SmilesReceivedHeader.png"];
    
    self.gridView = [[[AQGridView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    self.gridView.showsVerticalScrollIndicator = NO;
    self.gridView.backgroundColor = [UIColor brownColor];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    [self.gridView setContentSizeGrowsToFillBounds:TRUE];
    
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
    return 9;
}

- (AQGridViewCell *) gridView: (AQGridView *) _gridView cellForItemAtIndex: (NSUInteger) index
{    
    static NSString *smilesCellIdentifier = @"SmilesCellIdentifier";
    SmilesGridViewCell *cell = nil;
    cell = (SmilesGridViewCell *)[_gridView dequeueReusableCellWithIdentifier:smilesCellIdentifier];
    
    if (!cell) {
		cell = [[[SmilesGridViewCell alloc] initWithFrame:CGRectMake(0, 0, 100, 150)
                                          reuseIdentifier:smilesCellIdentifier] autorelease];   
    }
    
    //cell.backgroundColor = [UIColor purpleColor];
    
    //User *user = [self.users objectAtIndex:index];
    //[cell updateFromUser:user];
    
    return cell;
}

#pragma mark - Notifications


- (NSUInteger) gridView: (AQGridView *) gridView willSelectItemAtIndex: (NSUInteger) index
{
    //User *selectedUser = [self.users objectAtIndex:index];
    //[self userWasSelected:selectedUser];
    return index;
}

@end