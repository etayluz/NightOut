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
#import "User.h"

@implementation SmilesReceivedViewController

@synthesize gallery, fetchSmileGamesRequest;

- (void) dealloc
{        
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    self.gallery = [[[FramedGalleryView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
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

- (void) didFetchSmileGames:(NSMutableArray *)smileGames
{
    self.gallery.items = smileGames;
    [self.gallery reloadData];
}

- (void) refreshSmileGames
{
    [self.fetchSmileGamesRequest sendWithStatus:SmileGameStatusReceived];
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