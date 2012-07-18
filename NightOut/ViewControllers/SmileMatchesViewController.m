//
//  MatchesViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/17/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "SmileMatchesViewController.h"
#import "SmileGame.h"
#import "UIImageView+ScaledImage.h"
#import "ProfileViewController.h"

@interface SmileMatchesViewController ()

@end

@implementation SmileMatchesViewController

@synthesize gallery, fetchSmileGamesRequest, header, smileMatchesCountLabel;

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.gallery = [[[FramedGalleryView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    self.gallery.delegate = self;
    [self.view addSubview:gallery];
    
    /* Header image */
    UIImage *headerImage = [UIImage imageNamed:@"SmileMatchesHeader.png"];
    self.header = [[[UIImageView alloc] initWithImage:headerImage] autorelease];
    [self.view addSubview:self.header];
    
    self.gallery.topPadding = self.header.frame.size.height + 10;
    
    self.smileMatchesCountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(200, 0, 150, 50)] autorelease];
    self.smileMatchesCountLabel.font              = [UIFont fontWithName:@"Myriad Pro" size:24];
    self.smileMatchesCountLabel.textColor = [UIColor redColor];
    self.smileMatchesCountLabel.backgroundColor   = [UIColor clearColor];
    [self.view addSubview:self.smileMatchesCountLabel];

    
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] 
                                    initWithTitle: @"Nearby" 
                                    style:UIBarButtonItemStylePlain 
                                    target:self 
                                    action:@selector(myBackAction:)] autorelease];
    self.navigationItem.backBarButtonItem = backButton;
    
    self.fetchSmileGamesRequest = [[[FetchAllSmileGamesRequest alloc] init] autorelease];
    self.fetchSmileGamesRequest.delegate = self;

}

- (void) viewDidAppear:(BOOL) animated
{
    [self refreshSmileGames];
}

- (void) refreshSmileGames
{
    [self.fetchSmileGamesRequest showLoadingIndicatorForView:self.navigationController.view];
    [self.fetchSmileGamesRequest sendWithStatus:SmileGameStatusMatched];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) didFetchSmileGames:(NSMutableArray *)_smileGames
{
    self.gallery.items = _smileGames;
    [self.gallery reloadData];
    
    self.smileMatchesCountLabel.text = [NSString stringWithFormat:@"%d", self.gallery.items.count];
}

- (void) didSelectItem:(NSObject *)item
{
    SmileGame *smileGame = (SmileGame *)item;
    
    ProfileViewController *profileVC = [[[ProfileViewController alloc] init] autorelease];
    [self.navigationController pushViewController:profileVC animated:YES];
    [profileVC loadFromUserID:smileGame.match.OID];
}

- (void) updateCell:(FrameGridViewCell *)cell fromItem:(NSObject *)item
{
    SmileGame *game = (SmileGame *)item;
    [cell.imageView setImageWithURLScaled:game.match.thumb];
    
    cell.titleLabel.text = game.match.name;
    cell.subtitleLabel.text = game.match.network;
    cell.rightLabel.text = [game.match.age stringValue];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
