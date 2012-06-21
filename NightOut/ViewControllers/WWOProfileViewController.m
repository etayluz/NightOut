//
//  WWOProfileViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/18/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "WWOProfileViewController.h"
#import "UIImageView+WebCache.h"

@interface WWOProfileViewController ()

@end

@implementation WWOProfileViewController

@synthesize nameLabel, ageLabel, networkLabel, friendsLabel, profileImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) updateFromUser:(WWOUser *)user
{
    /* Image Label */
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.thumb]];

    /* Name Label */
    self.nameLabel.text = user.name;

    /* Age Label */
    self.ageLabel.text = [user.age stringValue];
    CGSize expectedLabelSize = [user.name sizeWithFont:self.nameLabel.font]; 
    CGRect newFrame = self.nameLabel.frame;
    newFrame.origin.x = expectedLabelSize.width + OFFSET_FROM_NAME_LABEL;
    self.ageLabel.frame = newFrame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)] autorelease];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(320, 700);
    [self.view addSubview:scrollView];

    self.profileImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 280)] autorelease];

    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 280, 100, 21)];
    self.nameLabel.backgroundColor = [UIColor clearColor];

    self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 280, 100, 21)];
    self.ageLabel.backgroundColor = [UIColor clearColor];
    

    [scrollView addSubview:self.profileImageView];
    [scrollView addSubview:self.nameLabel]; 
    [scrollView addSubview:self.ageLabel]; 
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
