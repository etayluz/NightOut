//
//  SmileGameViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "SmileGameViewController.h"
#import "ProfileViewController.h"

#import "SmileGameChoice.h"
#import "UIImageView+ScaledImage.h"

#import "MBProgressHUD.h"

@interface SmileGameViewController ()

@end

@implementation SmileGameViewController

@synthesize gallery, guessesRemainingLabel, header;

@synthesize fetchSmileGameRequest;
@synthesize guessSmileGameChoiceRequest;

@synthesize smileGame;
@synthesize selectedChoice;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *headerImage = [UIImage imageNamed:@"SmileGameHeader.png"];
    self.header = [[[UIImageView alloc] initWithImage:headerImage] autorelease];
    [self.view addSubview:self.header];
    
    self.guessesRemainingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(200, 0, 150, 50)] autorelease];
    self.guessesRemainingLabel.font              = [UIFont fontWithName:@"Myriad Pro" size:24];
    self.guessesRemainingLabel.textColor = [UIColor redColor];
    self.guessesRemainingLabel.backgroundColor   = [UIColor clearColor];
    [self.view addSubview:self.guessesRemainingLabel];
    
    self.fetchSmileGameRequest = [[[FetchSmileGameRequest alloc] init] autorelease];
    self.fetchSmileGameRequest.delegate = self;
    
    self.guessSmileGameChoiceRequest = [[[GuessSmileGameChoiceRequest alloc] init] autorelease];
    self.guessSmileGameChoiceRequest.delegate = self;
}

- (void) recreateGallery
{
    [self.gallery removeFromSuperview];
    self.gallery = nil;
    
    self.gallery = [[[FramedGalleryView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    self.gallery.delegate = self;
    self.gallery.topPadding = self.header.frame.size.height + 10;

    [self.view addSubview:gallery];
    [self.view sendSubviewToBack:gallery];
}

- (void) loadSmileGameFromID:(NSInteger)smileGameID
{
    [self.fetchSmileGameRequest showLoadingIndicatorForView:self.navigationController.view];
    [self.fetchSmileGameRequest send:smileGameID];
}

- (void) updateCell:(FrameGridViewCell *)cell fromItem:(NSObject *)item
{
    SmileGameChoice *choice = (SmileGameChoice *)item;
    
    cell.titleLabel.text = choice.user.name;
    [cell.imageView setImageWithURLScaled:choice.user.thumb];
    cell.subtitleLabel.text = choice.user.network;
    
    if (choice.user.age != nil)
        cell.rightLabel.text = [choice.user.age stringValue];
    
    if ([choice.status isEqualToString:@"no_match"])
        cell.alpha = 0.5;
    else if ([choice.status isEqualToString:@"match"])
        cell.titleLabel.textColor = [UIColor redColor];
    
}

- (void) updateSmileGame:(SmileGame *)_smileGame
{
    self.smileGame = _smileGame;
    
    [self recreateGallery];
    
    self.gallery.items = smileGame.choices;
    [self.gallery reloadData];
    
    self.guessesRemainingLabel.text = [NSString stringWithFormat:@"%d", self.smileGame.guessesRemaining];
}

- (void) didFetchSmileGame:(SmileGame *)_smileGame
{
    [self updateSmileGame:_smileGame];
}

- (void) didGuess:(SmileGame *)_smileGame
{
    [self updateSmileGame:_smileGame];
}

- (void) didSelectItem:(NSObject *)item
{
    self.selectedChoice = (SmileGameChoice *)item;
    NSLog(@"did select %@", self.selectedChoice.user.name);
    
    ProfileViewController *profileViewController = [[[ProfileViewController alloc] init] autorelease];
    profileViewController.delegate = self;
    profileViewController.hideSmileAndMessageButtons = YES;
    profileViewController.showChooseButton = YES;
    
    [self.navigationController pushViewController:profileViewController animated:YES];
    
    [profileViewController loadFromUserID:self.selectedChoice.user.OID];
}

- (void) didTapChooseButton
{
    [self.navigationController popToViewController:self animated:YES];
    
    [self.guessSmileGameChoiceRequest showLoadingIndicator:@"Guessing" forView:self.navigationController.view];
    [self.guessSmileGameChoiceRequest send:self.selectedChoice.smileGameID smileGameChoiceID:self.selectedChoice.OID];
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
