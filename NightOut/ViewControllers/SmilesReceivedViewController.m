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
#import "SmileGameViewController.h"

#import "User.h"
#import "SmileGame.h"
#import "UIImageView+ScaledImage.h"

@implementation SmilesReceivedViewController

@synthesize gallery, fetchSmileGamesRequest;
@synthesize header, smilesReceivedCountLabel;

- (void) dealloc
{        
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];    
    
    self.gallery = [[[FramedGalleryView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:FrameGridViewCellStyleLarge] autorelease];
    self.gallery.delegate = self;
    [self.view addSubview:gallery];

    /* Header image */
    UIImage *headerImage = [UIImage imageNamed:@"SmilesReceivedHeader.png"];
    self.header = [[[UIImageView alloc] initWithImage:headerImage] autorelease];
    [self.view addSubview:self.header];

    self.gallery.topPadding = self.header.frame.size.height + 10;
    
    self.smilesReceivedCountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(200, 0, 150, 50)] autorelease];
    self.smilesReceivedCountLabel.font              = [UIFont fontWithName:@"Myriad Pro" size:24];
    self.smilesReceivedCountLabel.textColor = [UIColor redColor];
    self.smilesReceivedCountLabel.backgroundColor   = [UIColor clearColor];
    [self.view addSubview:self.smilesReceivedCountLabel];

    
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

- (void) didFetchSmileGames:(NSMutableArray *)smileGames
{
    self.smilesReceivedCountLabel.text = [NSString stringWithFormat:@"%d", smileGames.count];
    self.gallery.items = smileGames;
    [self.gallery reloadData];
}

- (void) refreshSmileGames
{
    [self.fetchSmileGamesRequest showLoadingIndicatorForView:self.navigationController.view];
    [self.fetchSmileGamesRequest sendWithStatus:SmileGameStatusReceived];
}

- (void) updateCell:(FrameGridViewCell *)cell fromItem:(NSObject *)item
{
    SmileGame *game = (SmileGame *)item;
    
    cell.titleLabel.text = @"Guesses";
    cell.subtitleLabel.text = @"Remaining";
    cell.rightLabel.text = [NSString stringWithFormat:@"%d", game.guessesRemaining];
        
    [cell.imageView setImageWithURLScaled:game.sender.thumb];
}

- (void) didSelectItem:(NSObject *)item
{
    SmileGame *smileGame = (SmileGame *)item;
    
    SmileGameViewController *smileGameVC = [[[SmileGameViewController alloc] init] autorelease];
    [self.navigationController pushViewController:smileGameVC animated:YES];
    [smileGameVC loadSmileGameFromID:smileGame.OID];
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