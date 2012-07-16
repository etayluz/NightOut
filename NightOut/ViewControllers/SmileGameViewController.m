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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.gallery = [[[FramedGalleryView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    self.gallery.delegate = self;
    [self.view addSubview:gallery];
    
    self.fetchSmileGameRequest = [[[FetchSmileGameRequest alloc] init] autorelease];
    self.fetchSmileGameRequest.delegate = self;
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
}

- (void) didFetchSmileGame:(SmileGame *)smileGame
{
    self.gallery.items = smileGame.choices;
    [self.gallery reloadData];
    NSLog(@"did fetch smile game woo yeahhh");
}

- (void) didSelectItem:(NSObject *)item
{
    SmileGameChoice *choice = (SmileGameChoice *)item;
    NSLog(@"did select %@", choice.user.name);
    
    ProfileViewController *profileViewController = [[[ProfileViewController alloc] initWithStyle:ProfileViewStyleChoose] autorelease];
    [self.navigationController pushViewController:profileViewController animated:YES];
    
    [profileViewController loadFromUserID:choice.user.OID];
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
