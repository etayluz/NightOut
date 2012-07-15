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

@interface ProfileViewController ()
@property (nonatomic, retain) NSArray *users;
@property (nonatomic, retain) FetchUserRequest *fetchUserRequest;
@end

#define PROFILE_CONFIRM_START_SMILE_GAME 1

@implementation ProfileViewController
@synthesize vpanel;
@synthesize user;
@synthesize scrollView, nameLabel, ageLabel, networkLabel, friendsLabel, profileImageView;
@synthesize mutualFriendsView, interestsView, users, messageButton, smileButton, heightOffset;
@synthesize infoValueLabels;

@synthesize fetchUserRequest, startSmileGameRequest;

- (id) init
{
    self = [super init];
    if (self) {
        [Notification registerNotification:@"DidFetchUser" target:self selector:@selector(didFetchUser:)];
    }
    
    return self;
}

- (void) dealloc
{   
    self.scrollView = nil;
    self.nameLabel = nil;
    self.ageLabel = nil;
    self.networkLabel = nil;
    self.friendsLabel = nil;
    self.profileImageView = nil;
    self.mutualFriendsView = nil;
    self.interestsView = nil;
    self.users = nil;
    self.messageButton = nil;
    self.smileButton = nil;
    self.infoValueLabels = nil;
    self.fetchUserRequest = nil;
    
    [super dealloc];
}

- (void) updateFromUserID:(NSInteger)userID
{
    [self.fetchUserRequest send:userID];
}

- (void) didFetchUser:(User *)u
{
    [self updateFromUser:u];
}

- (void) updateFromUser:(User *)aUser
{
    [self buildSubviews];
    self.user = aUser;
    NSLog(@"update from user %@", aUser.name);
    
    self.title = [NSString stringWithFormat:@"%@'s Profile", aUser.name];
    
    self.nameLabel.text = aUser.name;
    
    [self.profileImageView setImageWithURLScaled:[aUser.pictures objectAtIndex:0]];
    
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
    [self.scrollView addSubview:self.nameLabel]; 
    self.heightOffset += 18;
    
    /* Age Label */
    self.ageLabel = [[[UILabel alloc] init] autorelease];
    self.ageLabel.font = [UIFont fontWithName:@"Myriad Pro" size:20];
    self.ageLabel.backgroundColor = [UIColor clearColor];
    self.ageLabel.textColor = [UIColor grayColor];
    [self.scrollView addSubview:self.ageLabel]; 
    self.heightOffset += 18;
    
    /* Smiles Button */
    self.smileButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [self.smileButton addTarget:self action:@selector(smilesButtonTap) forControlEvents:UIControlEventTouchDown];
    self.smileButton.frame = CGRectMake(5, self.heightOffset, 260, 40);    
    [self.scrollView addSubview:self.smileButton];
    UIImage *smileButtonImage = [UIImage imageNamed:@"SmileButton.png"]; 
    [self.smileButton setBackgroundImage:smileButtonImage forState:UIControlStateNormal];
    self.heightOffset += 0;
    
    /* Message Button */
    self.messageButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [self.messageButton addTarget:self action:@selector(messageButtonTap) forControlEvents:UIControlEventTouchDown];
    self.messageButton.frame = CGRectMake(265, self.heightOffset, 50, 40);
    [self.scrollView addSubview:self.messageButton];
    UIImage *messageButtonImage = [UIImage imageNamed:@"MessageButton2.png"];
    [self.messageButton setBackgroundImage:messageButtonImage forState:UIControlStateNormal];
    self.heightOffset += 35;
    
    /* Separator Label */
    UILabel *separator1 = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320, 21)] autorelease];
    separator1.font            = [UIFont boldSystemFontOfSize:12];
    separator1.backgroundColor = [UIColor clearColor];
    separator1.text = @"______________________________________________";
    separator1.textColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:separator1];
    self.heightOffset += 17;
    
    /* Friends Label */
    self.friendsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 150, 21)] autorelease];
    self.friendsLabel.text = @"Mutual Friends";
    self.friendsLabel.font            = [UIFont italicSystemFontOfSize:12];
    self.friendsLabel.backgroundColor = [UIColor clearColor];
    self.friendsLabel.textColor = [UIColor darkGrayColor];
    [self.scrollView addSubview:self.friendsLabel];
    self.heightOffset += 28;
    
    /* Mutual Friends Horizontal Scroll View */
    self.mutualFriendsView = [[[HorizontalGallery alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320-5, 100)] autorelease];
    self.mutualFriendsView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.mutualFriendsView];    
    [self.mutualFriendsView reloadData];
    self.heightOffset += 70;
    
    /* Separator Label */
    UILabel *separator2 = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320, 21)] autorelease];
    separator2.font            = [UIFont boldSystemFontOfSize:12];
    separator2.backgroundColor = [UIColor clearColor];
    separator2.text = @"______________________________________________";
    separator2.textColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:separator2];
    self.heightOffset += 17;
    
    /* General Info Label */
    [self generalInfo];
    
    /* Separator Label */
    UILabel *separator3 = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320, 21)] autorelease];
    separator3.font            = [UIFont boldSystemFontOfSize:12];
    separator3.backgroundColor = [UIColor clearColor];
    separator3.text = @"______________________________________________";
    separator3.textColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:separator3];
    self.heightOffset += 17;
    
    /* Music Label */
    UILabel *interestsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 100, 21)] autorelease];
    interestsLabel.font            = [UIFont italicSystemFontOfSize:12];
    interestsLabel.backgroundColor = [UIColor clearColor];
    interestsLabel.text = @"Interests";
    interestsLabel.textColor = [UIColor darkGrayColor];
    [self.scrollView addSubview:interestsLabel];
    self.heightOffset += 28;

    /* Music Scroll View */
    self.interestsView = [[[HorizontalGallery alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320-5, 100)] autorelease];
    [self.scrollView addSubview:self.interestsView];    
    self.heightOffset += 75;

    /* Separator Label */
    UILabel *separator4 = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320, 21)] autorelease];
    separator4.font            = [UIFont boldSystemFontOfSize:12];
    separator4.backgroundColor = [UIColor clearColor];
    separator4.text = @"______________________________________________";
    separator4.textColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:separator4];
    self.heightOffset += 14;
    
}


- (void) generalInfo
{
    UILabel *generalInfoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 100, 21)] autorelease];
    generalInfoLabel.font            = [UIFont italicSystemFontOfSize:12];
    self.nameLabel.font = [UIFont fontWithName:@"Myriad Pro" size:22];
    generalInfoLabel.backgroundColor = [UIColor clearColor];
    generalInfoLabel.text = @"General Info";
    generalInfoLabel.textColor = [UIColor darkGrayColor];
    [self.scrollView addSubview:generalInfoLabel];
    self.heightOffset += 28;
    //@synthesize hometownLabel, currentCityLabel, collegeLabel, interestedInLabel, relationshipStatusLabel, workLabel;
    
    NSArray *labels = [NSArray arrayWithObjects:@"Hometown", @"Current City", @"College", @"Interested In", @"Relationship Status", @"Work", nil];
    self.infoValueLabels = [NSMutableDictionary dictionary];
    
    for (NSString *element in labels) {
        [self createInfoLabel:element];
        self.heightOffset += 20;
    }
    
}


- (IBAction)handleImageTap:(UITapGestureRecognizer *)recognizer
{
    [self showProfilePictures];
}

- (void) createInfoLabel: (NSString *) caption
{
    UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, self.heightOffset, 100, 21)] autorelease];
//    infoLabel.font = [UIFont boldSystemFontOfSize:11];
    infoLabel.font = [UIFont fontWithName:@"Myriad Pro" size:15];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = [UIColor darkGrayColor];
    infoLabel.text = caption;
    [infoLabel sizeToFit];
    //NSLog(@"%f", infoLabel.frame.size.width);
    [self.scrollView addSubview:infoLabel];
    
    UILabel *infoValueLabel = [[[UILabel alloc] initWithFrame:CGRectMake(infoLabel.frame.size.width + 20, self.heightOffset-3, 100, 21)] autorelease];
//    infoValueLabel.font = [UIFont boldSystemFontOfSize:11];
    infoValueLabel.font = [UIFont fontWithName:@"Myriad" size:15];
    infoValueLabel.backgroundColor = [UIColor clearColor];
    infoValueLabel.textColor = [UIColor grayColor];
    
    [self.scrollView addSubview:infoValueLabel];
    [self.infoValueLabels setObject:infoValueLabel forKey:caption];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (alertView.tag) {
		case PROFILE_CONFIRM_START_SMILE_GAME:
		{
            //ok
            if (buttonIndex == 0) {
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
    // or if you are sure you wanna it always on top:
    // [aScrollView setContentOffset: CGPointMake(aScrollView.contentOffset.x, 0)];
}

- (void) showProfilePictures
{
    PhotoSliderViewController *photoSliderViewController = [[[PhotoSliderViewController alloc] init] autorelease];
    [self.navigationController pushViewController:photoSliderViewController animated:YES];
    [photoSliderViewController loadPhotoUrls:self.user.pictures];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
@end
