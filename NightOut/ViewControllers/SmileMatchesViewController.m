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

@synthesize gallery, fetchSmileGamesRequest, header;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.gallery = [[[FramedGalleryView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    self.gallery.delegate = self;
    [self.view addSubview:gallery];
    
    /* Header image */
    UIImage *headerImage = [UIImage imageNamed:@"SmilesSentHeader.png"];
    self.header = [[[UIImageView alloc] initWithImage:headerImage] autorelease];
    [self.view addSubview:self.header];
    
    self.gallery.topPadding = self.header.frame.size.height + 10;
    
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] 
                                    initWithTitle: @"Nearby" 
                                    style:UIBarButtonItemStylePlain 
                                    target:self 
                                    action:@selector(myBackAction:)] autorelease];
    self.navigationItem.backBarButtonItem = backButton;
    
    self.fetchSmileGamesRequest = [[[FetchAllSmileGamesRequest alloc] init] autorelease];
    self.fetchSmileGamesRequest.delegate = self;
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
