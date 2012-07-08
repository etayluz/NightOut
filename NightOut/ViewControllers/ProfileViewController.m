//
//  WWOProfileViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/18/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "ScaledImageView.h"
#import "ThumbViewCell.h"
#import "User.h"
#import "Notification.h"
#import "PhotoSliderViewController.h"
#import "ChatViewController.h"

@interface ProfileViewController ()
@property (nonatomic, retain) NSArray *users;
@property (nonatomic, retain) FetchUserRequest *fetchUserRequest;
@end

@implementation ProfileViewController
@synthesize vpanel;
@synthesize user;
@synthesize scrollView, nameLabel, ageLabel, networkLabel, friendsLabel, profileImageView;
@synthesize mutualFriendsView, interestsView, users, messageButton, smileButton, heightOffset;
@synthesize infoValueLabels;
@synthesize fetchUserRequest;

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
    
    [self.profileImageView setUrl:[aUser.pictures objectAtIndex:0]];
    
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
}

- (void) buildSubviews
{
    /* Initiate Scroll View */
    self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)] autorelease];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320, 1200);
    [self.view addSubview:self.scrollView];
    
    /* Image Label */
    self.profileImageView = [[[ScaledImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)] autorelease];
    self.profileImageView.userInteractionEnabled = YES;    
    [self.scrollView addSubview:self.profileImageView];
    
    self.heightOffset += 340;
    // Create gesture recognizer
    UITapGestureRecognizer *oneFingerOneTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)] autorelease];
    // Set required taps and number of touches
    [oneFingerOneTap setNumberOfTapsRequired:1];
    [oneFingerOneTap setNumberOfTouchesRequired:1];
    // Add the gesture to the view
    [self.profileImageView addGestureRecognizer:oneFingerOneTap];
    
    /* Name Label */ 
    self.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 100, 21)] autorelease];
    self.nameLabel.font            = [UIFont boldSystemFontOfSize:15];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.nameLabel]; 
    self.heightOffset += 10;
    
    /* Age Label */
    self.ageLabel = [[[UILabel alloc] init] autorelease];
    self.ageLabel.font            = [UIFont boldSystemFontOfSize:13];
    self.ageLabel.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.ageLabel]; 
    self.heightOffset += 13;
    
    /* Message Button */
    self.messageButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [self.messageButton addTarget:self action:@selector(messageButtonTap) forControlEvents:UIControlEventTouchDown];
    [self.messageButton setTitle: @"Message" forState: UIControlStateNormal];
    self.messageButton.frame = CGRectMake(5, self.heightOffset, 300, 30);
    [self.scrollView addSubview:self.messageButton];
    self.heightOffset += 35;
    
    /* Smiles Button */
    self.smileButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [self.smileButton addTarget:self action:@selector(smilesButtonTap) forControlEvents:UIControlEventTouchDown];
    [self.smileButton setTitle: @"Smiles" forState: UIControlStateNormal];
    self.smileButton.frame = CGRectMake(5, self.heightOffset, 300, 30);    
    [self.scrollView addSubview:self.smileButton];
    self.heightOffset += 18;
    
    /* Separator Label */
    UILabel *separator1 = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320, 21)] autorelease];
    separator1.font            = [UIFont boldSystemFontOfSize:12];
    separator1.backgroundColor = [UIColor clearColor];
    separator1.text = @"_____________________________________________";
    [self.scrollView addSubview:separator1];
    self.heightOffset += 14;
    
    /* Friends Label */
    self.friendsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 150, 21)] autorelease];
    self.friendsLabel.text = @"Mutual Friends";
    self.friendsLabel.font            = [UIFont boldSystemFontOfSize:12];
    self.friendsLabel.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.friendsLabel];
    self.heightOffset += 20;
    
    /* Mutual Friends Horizontal Scroll View */
    self.mutualFriendsView = [[[HorizontalGallery alloc] initWithFrame:CGRectMake(0, self.heightOffset, 320, 100)] autorelease];
    [self.scrollView addSubview:self.mutualFriendsView];    
    [self.mutualFriendsView reloadData];
    self.mutualFriendsView.backgroundColor = [UIColor orangeColor];
    self.heightOffset += 110;
    
    /* Separator Label */
    UILabel *separator2 = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320, 21)] autorelease];
    separator2.font            = [UIFont boldSystemFontOfSize:12];
    separator2.backgroundColor = [UIColor clearColor];
    separator2.text = @"_____________________________________________";
    [self.scrollView addSubview:separator2];
    self.heightOffset += 14;
    
    /* General Info Label */
    [self generalInfo];
    
    /* Separator Label */
    UILabel *separator3 = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320, 21)] autorelease];
    separator3.font            = [UIFont boldSystemFontOfSize:12];
    separator3.backgroundColor = [UIColor clearColor];
    separator3.text = @"_____________________________________________";
    [self.scrollView addSubview:separator3];
    self.heightOffset += 14;
    
    /* Music Label */
    UILabel *interestsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 100, 21)] autorelease];
    interestsLabel.font            = [UIFont boldSystemFontOfSize:12];
    interestsLabel.backgroundColor = [UIColor clearColor];
    interestsLabel.text = @"Interests";
    [self.scrollView addSubview:interestsLabel];
    self.heightOffset += 20;

    /* Music Scroll View */
    self.interestsView = [[[HorizontalGallery alloc] initWithFrame:CGRectMake(0, self.heightOffset, 320, 100)] autorelease];
    [self.scrollView addSubview:self.interestsView];    
    self.heightOffset += 110;

    /* Separator Label */
    UILabel *separator4 = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320, 21)] autorelease];
    separator4.font            = [UIFont boldSystemFontOfSize:12];
    separator4.backgroundColor = [UIColor clearColor];
    separator4.text = @"_____________________________________________";
    [self.scrollView addSubview:separator4];
    self.heightOffset += 14;
    
}


- (void) generalInfo
{
    UILabel *generalInfoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 100, 21)] autorelease];
    generalInfoLabel.font            = [UIFont boldSystemFontOfSize:12];
    generalInfoLabel.backgroundColor = [UIColor clearColor];
    generalInfoLabel.text = @"General Info";
    [self.scrollView addSubview:generalInfoLabel];
    self.heightOffset += 20;
    //@synthesize hometownLabel, currentCityLabel, collegeLabel, interestedInLabel, relationshipStatusLabel, workLabel;
    
    NSArray *labels = [NSArray arrayWithObjects:@"Hometown", @"Current City", @"College", @"Interested In", @"Relationship Status", @"Work", nil];
    self.infoValueLabels = [NSMutableDictionary dictionary];
    
    for (NSString *element in labels) {
        [self createInfoLabel:element];
        self.heightOffset += 15;
    }
    
}


- (IBAction)handleImageTap:(UITapGestureRecognizer *)recognizer
{
    [self showProfilePictures];
}

- (void) createInfoLabel: (NSString *) caption
{
    UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, self.heightOffset, 100, 21)] autorelease];
    infoLabel.font = [UIFont boldSystemFontOfSize:10];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.text = caption;
    [infoLabel sizeToFit];
    //NSLog(@"%f", infoLabel.frame.size.width);
    [self.scrollView addSubview:infoLabel];
    
    UILabel *infoValueLabel = [[[UILabel alloc] initWithFrame:CGRectMake(infoLabel.frame.size.width + 20, self.heightOffset-3.5, 100, 21)] autorelease];
    infoValueLabel.font = [UIFont boldSystemFontOfSize:10];
    infoValueLabel.backgroundColor = [UIColor clearColor];
    
    [self.scrollView addSubview:infoValueLabel];
    [self.infoValueLabels setObject:infoValueLabel forKey:caption];
}


- (void) messageButtonTap
{
    [self showMessages];
}

- (void) smilesButtonTap
{
    
}

- (void) showMessages
{
    ChatViewController *chatVC = [[[ChatViewController alloc] init] autorelease];    
    chatVC.title = self.user.name;
    [self.navigationController pushViewController:chatVC animated:YES];
    
    [chatVC updateFromUserID:self.user.userID];
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
