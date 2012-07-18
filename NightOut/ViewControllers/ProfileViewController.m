//
//  WWOProfileViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/18/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "ThumbViewCell.h"
#import "User.h"
#import "Notification.h"
#import "PhotoSliderViewController.h"
#import "ChatViewController.h"
#import "UIImageView+ScaledImage.h"
#import "GradientButton.h"

@interface ProfileViewController ()

@property (nonatomic, retain) NSArray *users;
@property (nonatomic, retain) FetchUserRequest *fetchUserRequest;

@property (nonatomic, retain) StartSmileGameRequest *startSmileGameRequest;

@property (nonatomic, retain) User *user;

@property (nonatomic, retain)  UILabel *nameLabel;
@property (nonatomic, retain)  UILabel *ageLabel;
@property (nonatomic, retain)  UIImageView *profileImageView;

@property (nonatomic, retain)  HorizontalGallery *mutualFriendsView;
@property (nonatomic, retain)  HorizontalGallery *interestsView;

@property (nonatomic, retain)  UIButton *messageButton;
@property (nonatomic, retain)  UIButton *smileButton;
@property (nonatomic, retain)  UIScrollView *scrollView;

@property (nonatomic, retain) NSMutableDictionary *infoValueLabels;
@property (nonatomic)  NSInteger heightOffset;

@end

#define PROFILE_CONFIRM_START_SMILE_GAME 1

@implementation ProfileViewController
@synthesize delegate;
@synthesize user;
@synthesize scrollView, nameLabel, ageLabel, profileImageView;
@synthesize mutualFriendsView, interestsView, users, messageButton, smileButton, heightOffset;
@synthesize infoValueLabels;
@synthesize hideSmileAndMessageButtons, hideMutualFriends, showChooseButton, autoUpdateTitle;
@synthesize fetchUserRequest, startSmileGameRequest;
@synthesize fetchCurrentUserOnLoad;
@synthesize chooseFooter, chooseButton;

- (id) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) dealloc
{   
    self.scrollView = nil;
    self.nameLabel = nil;
    self.ageLabel = nil;
    self.profileImageView = nil;
    self.mutualFriendsView = nil;
    self.interestsView = nil;
    self.users = nil;
    self.messageButton = nil;
    self.smileButton = nil;
    self.infoValueLabels = nil;
    self.fetchUserRequest = nil;
    self.chooseFooter = nil;
    self.chooseButton = nil;
    
    [super dealloc];
}

- (void) loadFromUserID:(NSInteger)userID
{
    [self.fetchUserRequest showLoadingIndicatorForView:self.navigationController.view];
    [self.fetchUserRequest send:userID];
}

- (void) loadCurrentUser
{
    [self.fetchUserRequest showLoadingIndicatorForView:self.navigationController.view];
    [self.fetchUserRequest sendForCurrentUser];
}

- (void) didFetchUser:(User *)u
{
    [self loadFromUser:u];
}

- (void) loadFromUser:(User *)aUser
{
    [self buildSubviews];
    self.user = aUser;
    NSLog(@"update from user %@", aUser.name);
    
    if (self.autoUpdateTitle)
        self.title = [NSString stringWithFormat:@"%@'s Profile", aUser.name];
    
    self.nameLabel.text = aUser.name;
    
    [self.profileImageView setImageWithURLScaled:[aUser.photos objectAtIndex:0]];
    
    self.ageLabel.text = [aUser.age stringValue];
    
    CGSize expectedLabelSize = [aUser.name sizeWithFont:self.nameLabel.font];
    CGRect newFrame = self.nameLabel.frame;
    newFrame.origin.x = expectedLabelSize.width + OFFSET_FROM_NAME_LABEL;
    self.ageLabel.frame = newFrame;
    
    [self updateInfoLabel:@"Hometown" value:aUser.hometown];
    [self updateInfoLabel:@"Current City" value:aUser.currentCity];
    [self updateInfoLabel:@"College" value:aUser.college];
    [self updateInfoLabel:@"Interested In" value:aUser.interestedIn];
    [self updateInfoLabel:@"Relationship Status" value:aUser.relationshipStatus];
    [self updateInfoLabel:@"Work" value:aUser.work];
    
    self.mutualFriendsView.items = self.user.mutualFriends;
    [self.mutualFriendsView reloadData];
    
    self.interestsView.items = self.user.interests;
    [self.interestsView reloadData];
}

- (void) updateInfoLabel:(NSString *) title value: (NSString *) aValue
{
    UILabel *infoLabel = [self.infoValueLabels objectForKey:title];
    infoLabel.text = aValue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fetchUserRequest = [[[FetchUserRequest alloc] init] autorelease];
    self.fetchUserRequest.delegate = self;
    
    self.startSmileGameRequest = [[[StartSmileGameRequest alloc] init] autorelease];
    self.startSmileGameRequest.delegate = self;
    
    if (self.fetchCurrentUserOnLoad) {
        [self.fetchUserRequest showLoadingIndicatorForView:self.navigationController.view];
        [self.fetchUserRequest sendForCurrentUser];
    }
}

- (void) buildSubviews
{
    /* Initiate Scroll View */
    self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)] autorelease];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.929 green:0.933 blue:0.863 alpha:1];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320, 1200);
    [self.view addSubview:self.scrollView];
    
    /* Image Label */
    self.profileImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)] autorelease];
    self.profileImageView.userInteractionEnabled = YES;    
    [self.scrollView addSubview:self.profileImageView];
    
    self.heightOffset += 325;
    // Create gesture recognizer
    UITapGestureRecognizer *oneFingerOneTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)] autorelease];
    // Set required taps and number of touches
    [oneFingerOneTap setNumberOfTapsRequired:1];
    [oneFingerOneTap setNumberOfTouchesRequired:1];
    
    // Add the gesture to the view
    [self.profileImageView addGestureRecognizer:oneFingerOneTap];
    
    /* Name Label */ 
    self.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 100, 31)] autorelease];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor darkGrayColor];
    self.nameLabel.font = [UIFont fontWithName:@"Myriad Pro" size:24];
    [self.scrollView addSubview:self.nameLabel]; 
    
    /* Age Label */
    self.ageLabel = [[[UILabel alloc] init] autorelease];
    self.ageLabel.font = [UIFont fontWithName:@"Myriad Pro" size:24];
    self.ageLabel.backgroundColor = [UIColor clearColor];
    self.ageLabel.textColor = [UIColor grayColor];
    [self.scrollView addSubview:self.ageLabel]; 
    self.heightOffset += 24;
    
    if (self.hideSmileAndMessageButtons == NO)
        [self createSmileAndMessageButtons];
    
    if (self.hideMutualFriends == NO)
        [self createMutualFriendsSection];
        
    [self createGeneralInfoSection];
    [self createInterestsSection];
    [self createChooseFooter];
    
    if (self.showChooseButton == YES)
        [self showChooseDialog];
}

- (void) createSmileAndMessageButtons
{
    self.heightOffset += 8;
    
    /* Smiles Button */
    self.smileButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.smileButton addTarget:self action:@selector(smilesButtonTap) forControlEvents:UIControlEventTouchUpInside];
    self.smileButton.frame = CGRectMake(5, self.heightOffset, 260, 40);    
    UIImage *smileButtonImage = [UIImage imageNamed:@"SmileButton.png"]; 
    [self.smileButton setBackgroundImage:smileButtonImage forState:UIControlStateNormal];    
    [self.scrollView addSubview:self.smileButton];
    
    /* Message Button */
    self.messageButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.messageButton addTarget:self action:@selector(messageButtonTap) forControlEvents:UIControlEventTouchUpInside];
    self.messageButton.frame = CGRectMake(265, self.heightOffset, 50, 40);
    [self.scrollView addSubview:self.messageButton];
    UIImage *messageButtonImage = [UIImage imageNamed:@"MessageButton.png"];
    [self.messageButton setBackgroundImage:messageButtonImage forState:UIControlStateNormal];
    self.heightOffset += 40;
}

- (void) createMutualFriendsSection
{
    [self createSeperatorWithTitle:@"Mutual Friends"];
    
    /* Mutual Friends Horizontal Scroll View */
    self.mutualFriendsView = [[[HorizontalGallery alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320 - 5, 100)] autorelease];
    self.mutualFriendsView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.mutualFriendsView];    
    [self.mutualFriendsView reloadData];
    self.heightOffset += 70;
}

- (void) createGeneralInfoSection
{
    [self createSeperatorWithTitle:@"General Info"];
        
    NSArray *labels = [NSArray arrayWithObjects:@"Hometown", @"Current City", @"College", @"Interested In", @"Relationship Status", @"Work", nil];
    self.infoValueLabels = [NSMutableDictionary dictionary];
    
    for (NSString *element in labels) {
        [self createInfoLabel:element];
        self.heightOffset += 20;
    }
}

- (void) createInterestsSection
{
    [self createSeperatorWithTitle:@"Interests"];
    
    /* Interests Scroll View */
    self.interestsView = [[[HorizontalGallery alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320-5, 100)] autorelease];
    [self.scrollView addSubview:self.interestsView];    
    self.heightOffset += 75;
}

- (void) createSeperator
{
    UILabel *separator = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320, 21)] autorelease];
    separator.font            = [UIFont boldSystemFontOfSize:12];
    separator.backgroundColor = [UIColor clearColor];
    separator.text = @"______________________________________________";
    separator.textColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:separator];
    
    self.heightOffset += 28;
}

- (void) createSeperatorWithTitle:(NSString *)title
{
    self.heightOffset += 14;
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 150, 21)] autorelease];
    label.text = title;
    label.font            = [UIFont fontWithName:@"Myriad Pro" size:18];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkGrayColor];
    [self.scrollView addSubview:label];
    
    [self createSeperator];
}


- (IBAction)handleImageTap:(UITapGestureRecognizer *)recognizer
{
    [self showProfilePictures];
}

- (void) createInfoLabel: (NSString *) caption
{
    UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, self.heightOffset, 100, 21)] autorelease];
    infoLabel.font = [UIFont fontWithName:@"Myriad Pro" size:15];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = [UIColor darkGrayColor];
    infoLabel.text = caption;
    [infoLabel sizeToFit];
    [self.scrollView addSubview:infoLabel];
    
    UILabel *infoValueLabel = [[[UILabel alloc] initWithFrame:CGRectMake(infoLabel.frame.size.width + 20, self.heightOffset-3, 100, 21)] autorelease];
    infoValueLabel.font = [UIFont fontWithName:@"Myriad" size:15];
    infoValueLabel.backgroundColor = [UIColor clearColor];
    infoValueLabel.textColor = [UIColor grayColor];
    
    [self.scrollView addSubview:infoValueLabel];
    [self.infoValueLabels setObject:infoValueLabel forKey:caption];
}

/* Choose Him / Her Section */
- (void) createChooseFooter
{
    CGRect frame = CGRectMake(0, self.view.frame.size.height - 55, self.view.frame.size.width, 55);
    self.chooseFooter = [[[UIView alloc] initWithFrame:frame] autorelease];
    self.chooseFooter.backgroundColor = [UIColor darkGrayColor];
    self.chooseFooter.hidden = YES;
    
    self.chooseButton = [[[GradientButton alloc] initWithFrame:CGRectMake(20, 10, 280, 35)] autorelease];
    [self.chooseButton setTitle:@"Choose her :)" forState:UIControlStateNormal];
    [self.chooseButton useBlackStyle];
    [self.chooseFooter addSubview:self.chooseButton];
        
    [self.chooseButton addTarget:self action:@selector(didTapChooseButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:chooseFooter];
}

- (void) didTapChooseButton
{
    [self.delegate didTapChooseButton];
}

- (void) messageButtonTap
{
    [self showMessages];
}

- (void) smilesButtonTap
{
    // confirm the deletion..
	UIAlertView *alert = [[UIAlertView alloc] init];
    alert.tag = PROFILE_CONFIRM_START_SMILE_GAME;
	[alert setTitle:@"Smile Game"];
	[alert setMessage:[NSString stringWithFormat:@"Start smile game with %@?", self.user.name]];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];
	[alert release];
}

- (void)showChooseDialog
{
    self.chooseFooter.hidden = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (alertView.tag) {
		case PROFILE_CONFIRM_START_SMILE_GAME:
		{
            //ok
            if (buttonIndex == 0) {
                [self.startSmileGameRequest showLoadingIndicator:@"Sending Smile" forView:self.navigationController.view];
                [self.startSmileGameRequest send:self.user.OID];
            }
            //cancel
            else if (buttonIndex == 1) {
            }
            
			break;
		default:
			NSLog(@"WebAppListVC.alertView: clickedButton at index. Unknown alert type");
		}
	}	
}

- (void) didStartSmileGame
{
    NSLog(@"did start smile game");
}

- (void) showMessages
{
    ChatViewController *chatVC = [[[ChatViewController alloc] init] autorelease];    
    chatVC.title = self.user.name;
    [self.navigationController pushViewController:chatVC animated:YES];
    
    [chatVC updateFromConversationID:self.user.conversationID];
}

- (NSUInteger) gridView: (AQGridView *) gridView willSelectItemAtIndex: (NSUInteger) index
{
    return index;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(90, 120) );
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [aScrollView setContentOffset: CGPointMake(aScrollView.contentOffset.x, 0)];
}

- (void) showProfilePictures
{
    PhotoSliderViewController *photoSliderViewController = [[[PhotoSliderViewController alloc] init] autorelease];
    [self.navigationController pushViewController:photoSliderViewController animated:YES];
    [photoSliderViewController loadPhotoUrls:self.user.photos];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
@end
