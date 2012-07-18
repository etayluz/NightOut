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
#import "FrameGridViewCell.h"

#import "User.h"
#import "SmileGame.h"

#import "AQGridView.h"

#import "UIImageView+ScaledImage.h"

@implementation SmilesSentViewController

@synthesize fetchSmileGamesRequest;
@synthesize gallery;
@synthesize header;
@synthesize smilesSentCountLabel;

- (void) dealloc
{
    self.fetchSmileGamesRequest = nil;
    self.gallery = nil;
    self.header = nil;
    
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.gallery = [[[FramedGalleryView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    self.gallery.delegate = self;
    [self.view addSubview:gallery];
    
    /* Header image */
    UIImage *headerImage = [UIImage imageNamed:@"SmilesSentHeader.png"];
    self.header = [[[UIImageView alloc] initWithImage:headerImage] autorelease];
    [self.view addSubview:self.header];
    
    self.gallery.topPadding = self.header.frame.size.height + 10;
    
    self.smilesSentCountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(200, 0, 150, 50)] autorelease];
    self.smilesSentCountLabel.font              = [UIFont fontWithName:@"Myriad Pro" size:24];
    self.smilesSentCountLabel.textColor = [UIColor redColor];
    self.smilesSentCountLabel.backgroundColor   = [UIColor clearColor];
    [self.view addSubview:self.smilesSentCountLabel];
    
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] 
                                   initWithTitle: @"Nearby" 
                                   style:UIBarButtonItemStylePlain 
                                   target:self 
                                   action:@selector(myBackAction:)] autorelease];
    self.navigationItem.backBarButtonItem = backButton;
    
    self.fetchSmileGamesRequest = [[[FetchAllSmileGamesRequest alloc] init] autorelease];
    self.fetchSmileGamesRequest.delegate = self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self refreshSmileGames];
}

- (void) refreshSmileGames
{
    [self.fetchSmileGamesRequest showLoadingIndicatorForView:self.navigationController.view];
    [self.fetchSmileGamesRequest sendWithStatus:SmileGameStatusSent];
}

- (void) didFetchSmileGames:(NSMutableArray *)_smileGames
{
    self.gallery.items = _smileGames;
    [self.gallery reloadData];
    
    self.smilesSentCountLabel.text = [NSString stringWithFormat:@"%d", self.gallery.items.count];
}

- (void) updateCell:(FrameGridViewCell *)cell fromItem:(NSObject *)item
{
    SmileGame *game = (SmileGame *)item;
    [cell.imageView setImageWithURLScaled:game.receiver.thumb];
        
    cell.titleLabel.text = game.receiver.name;
    cell.subtitleLabel.text = game.receiver.network;
    cell.rightLabel.text = [game.receiver.age stringValue];
}

- (void) didSelectItem:(NSObject *)item
{
    SmileGame *smileGame = (SmileGame *)item;
    
    ProfileViewController *profileVC = [[[ProfileViewController alloc] init] autorelease];
    profileVC.hideSmileAndMessageButtons = YES;
    
    [self.navigationController pushViewController:profileVC animated:YES];
    [profileVC loadFromUserID:smileGame.receiver.OID];
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
