//
//  SmilesSentViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "Notification.h"

#import "ProfileViewController.h"
#import "SmilesSentViewController.h"
#import "SmilesGridViewCell.h"

#import "User.h"
#import "SmileGame.h"

#import "AQGridView.h"

@implementation SmilesSentViewController

@synthesize fetchSmileGamesRequest;
@synthesize gallery;

- (void) dealloc
{
    [Notification unregisterNotification:@"DidFetchNearbyUsers" target:self];
    
    self.fetchSmileGamesRequest = nil;
    self.gallery = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.gallery = [[[FramedGalleryView alloc] init] autorelease];
    [self.view addSubview:gallery];
    
    
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] 
                                   initWithTitle: @"Nearby" 
                                   style:UIBarButtonItemStylePlain 
                                   target:self 
                                   action:@selector(myBackAction:)] autorelease];
    self.navigationItem.backBarButtonItem = backButton;
    
    self.fetchSmileGamesRequest = [[[FetchSmileGamesRequest alloc] init] autorelease];
    self.fetchSmileGamesRequest.delegate = self;
    [self refreshSmileGames];
}

- (void) refreshSmileGames
{
    [self.fetchSmileGamesRequest sendWithStatus:SmileGameStatusSent];
}

- (void) didFetchSmileGames:(NSMutableArray *)_smileGames
{
    self.gallery.items = _smileGames;
    [self.gallery reloadData];
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(100, 110) );
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

@end
