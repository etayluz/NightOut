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

@interface SmileGameViewController ()

@end

@implementation SmileGameViewController

@synthesize gallery;

@synthesize fetchSmileGameRequest;
@synthesize guessSmileGameChoiceRequest;

@synthesize smileGame;
@synthesize selectedChoice;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.gallery = [[[FramedGalleryView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    self.gallery.delegate = self;
    [self.view addSubview:gallery];
    
    self.fetchSmileGameRequest = [[[FetchSmileGameRequest alloc] init] autorelease];
    self.fetchSmileGameRequest.delegate = self;
    
    self.guessSmileGameChoiceRequest = [[[GuessSmileGameChoiceRequest alloc] init] autorelease];
    self.guessSmileGameChoiceRequest.delegate = self;
}

- (void) loadSmileGameFromID:(NSInteger)smileGameID
{
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
}

- (void) didFetchSmileGame:(SmileGame *)_smileGame
{
    self.smileGame = _smileGame;
    [self refreshFromModel];
    NSLog(@"did fetch smile game woo yeahhh");
}

- (void) didGuess:(SmileGame *)_smileGame
{
    self.smileGame = _smileGame;
    [self refreshFromModel];
}

- (void) refreshFromModel
{
    self.gallery.items = [NSMutableArray array];
    [self.gallery reloadData];
    
    self.gallery.items = smileGame.choices;
    [self.gallery reloadData];
}

- (void) didSelectItem:(NSObject *)item
{
    self.selectedChoice = (SmileGameChoice *)item;
    NSLog(@"did select %@", self.selectedChoice.user.name);
    
    ProfileViewController *profileViewController = [[[ProfileViewController alloc] initWithStyle:ProfileViewStyleChoose] autorelease];
    profileViewController.delegate = self;
    
    [self.navigationController pushViewController:profileViewController animated:YES];
    
    [profileViewController loadFromUserID:self.selectedChoice.user.OID];
}

- (void) didTapChooseButton
{
    NSLog(@"****chose %@", self.selectedChoice.user.name);
    [self.navigationController popToViewController:self animated:YES];
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
