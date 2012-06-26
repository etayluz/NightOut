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
#import "ServerInterface.h"
#import "PhotoSliderViewController.h"

@interface ProfileViewController ()
@property (nonatomic, retain) NSArray *users;

@end

@implementation ProfileViewController

@synthesize user;
@synthesize scrollView, nameLabel, ageLabel, networkLabel, friendsLabel, profileImageView;
@synthesize friendsScrollView, musicScrollView, placesScrollView, users, messageButton, smileButton, heightOffset;
@synthesize infoValueLabels;

- (id) init
{
    self = [super init];
    if (self) {
        [Notification registerNotification:@"DidFetchUser" target:self selector:@selector(didFetchUser:)];
        
        [[ServerInterface sharedManager] fetchUser];
    }
    
    return self;
}

- (void) dealloc
{
    [Notification unregisterNotification:@"DidFetchUser" target:self];
    
    [self.infoValueLabels release];
    
    [super dealloc];
}

- (void) didFetchUser:(NSNotification *) notification
{
    User *u = [notification.userInfo objectForKey:@"data"];
    [self updateFromUser:u];
    NSLog(@"fetched user name = %@", user.name);
}

- (void) updateFromUser:(User *)aUser
{
    [self buildSubviews];
    self.user = aUser;
    NSLog(@"update from user %@", aUser.name);
    
    self.nameLabel.text = aUser.name;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:[aUser.pictures objectAtIndex:0]]];
    self.ageLabel.text = [aUser.age stringValue];
    
    CGSize expectedLabelSize = [aUser.name sizeWithFont:self.nameLabel.font];
    CGRect newFrame = self.nameLabel.frame;
    newFrame.origin.x = expectedLabelSize.width + OFFSET_FROM_NAME_LABEL;
    self.ageLabel.frame = newFrame;
    
    //NSArray *labels = [NSArray arrayWithObjects:@"Hometown", @"Current City", @"College", @"Interested In", @"Relationship Status", @"Work", nil];
    [self updateInfoLabel:@"Hometown" value:aUser.hometown];
    [self updateInfoLabel:@"Current City" value:aUser.currentCity];
    [self updateInfoLabel:@"College" value:aUser.college];
    [self updateInfoLabel:@"Interested In" value:aUser.interestedIn];
    [self updateInfoLabel:@"Relationship Status" value:aUser.relationshipStatus];
    [self updateInfoLabel:@"Work" value:aUser.work];
    
    [self.friendsScrollView reloadData];
    [self.musicScrollView reloadData];
    [self.placesScrollView reloadData];
}

- (void) updateInfoLabel:(NSString *) title value: (NSString *) aValue
{
    UILabel *infoLabel = [self.infoValueLabels objectForKey:title];
    infoLabel.text = aValue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) buildSubviews
{
    /* Initiate Scroll View */
    self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)] autorelease];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320, 1000);
    [self.view addSubview:self.scrollView];
    
    /* Image Label */
    self.profileImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 280)] autorelease];
    self.profileImageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.profileImageView];
    self.heightOffset += 280;
    // Create gesture recognizer
    UITapGestureRecognizer *oneFingerOneTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)] autorelease];
    // Set required taps and number of touches
    [oneFingerOneTap setNumberOfTapsRequired:1];
    [oneFingerOneTap setNumberOfTouchesRequired:1];
    // Add the gesture to the view
    [self.profileImageView addGestureRecognizer:oneFingerOneTap];
    
    /* Name Label */
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 100, 21)];
    self.nameLabel.font            = [UIFont boldSystemFontOfSize:15];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.nameLabel]; 
    self.heightOffset += 10;
    
    /* Age Label */
    self.ageLabel = [[UILabel alloc] init];
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
    UILabel *separator1 = [[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320, 21)];
    separator1.font            = [UIFont boldSystemFontOfSize:12];
    separator1.backgroundColor = [UIColor clearColor];
    separator1.text = @"_____________________________________________";
    [self.scrollView addSubview:separator1];
    self.heightOffset += 14;
    
    /* Friends Label */
    self.friendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 150, 21)];
    self.friendsLabel.font            = [UIFont boldSystemFontOfSize:12];
    self.friendsLabel.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.friendsLabel];
    self.heightOffset += 20;
    
    /* Friends Horizontal Scroll View */
    self.friendsScrollView = [[[AQGridView alloc] initWithFrame:CGRectMake(0, self.heightOffset, 320, 65)] autorelease];
    self.friendsScrollView.layoutDirection = AQGridViewLayoutDirectionHorizontal;
    self.friendsScrollView.showsVerticalScrollIndicator = NO;
    self.friendsScrollView.showsHorizontalScrollIndicator = NO;
    self.friendsScrollView.delegate = self;
    self.friendsScrollView.dataSource = self;
    [self.friendsScrollView setContentSizeGrowsToFillBounds:NO];
    self.friendsScrollView.gridHeaderView.hidden = YES;
    self.friendsScrollView.gridFooterView.hidden = YES;  
    self.friendsScrollView.resizesCellWidthToFit = YES;
    [self.scrollView addSubview:self.friendsScrollView];    
    [self.friendsScrollView reloadData];
    self.heightOffset += 50;
    
    /* Separator Label */
    UILabel *separator2 = [[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320, 21)];
    separator2.font            = [UIFont boldSystemFontOfSize:12];
    separator2.backgroundColor = [UIColor clearColor];
    separator2.text = @"_____________________________________________";
    [self.scrollView addSubview:separator2];
    self.heightOffset += 14;
    
    /* General Info Label */
    [self generalInfo];
    
    /* Separator Label */
    UILabel *separator3 = [[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320, 21)];
    separator3.font            = [UIFont boldSystemFontOfSize:12];
    separator3.backgroundColor = [UIColor clearColor];
    separator3.text = @"_____________________________________________";
    [self.scrollView addSubview:separator3];
    self.heightOffset += 14;
    
    /* Music Label */
    UILabel *musicLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 100, 21)] autorelease];
    musicLabel.font            = [UIFont boldSystemFontOfSize:12];
    musicLabel.backgroundColor = [UIColor clearColor];
    musicLabel.text = @"Music";
    [self.scrollView addSubview:musicLabel];
    self.heightOffset += 20;

    /* Music Scroll View */
    self.musicScrollView = [[[AQGridView alloc] initWithFrame:CGRectMake(0, self.heightOffset, 320, 65)] autorelease];
    self.musicScrollView.layoutDirection = AQGridViewLayoutDirectionHorizontal;
    self.musicScrollView.showsVerticalScrollIndicator = NO;
    self.musicScrollView.showsHorizontalScrollIndicator = NO;
    self.musicScrollView.delegate = self;
    self.musicScrollView.dataSource = self;
    [self.musicScrollView setContentSizeGrowsToFillBounds:NO];
    self.musicScrollView.gridHeaderView.hidden = YES;
    self.musicScrollView.gridFooterView.hidden = YES;
    self.musicScrollView.resizesCellWidthToFit = YES;
    [self.scrollView addSubview:self.musicScrollView];    
    [self.musicScrollView reloadData];
    self.heightOffset += 60;

    /* Separator Label */
    UILabel *separator4 = [[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 320, 21)];
    separator4.font            = [UIFont boldSystemFontOfSize:12];
    separator4.backgroundColor = [UIColor clearColor];
    separator4.text = @"_____________________________________________";
    [self.scrollView addSubview:separator4];
    self.heightOffset += 14;

    /* Recent Places Label */
    UILabel *placesLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 100, 21)] autorelease];
    placesLabel.font            = [UIFont boldSystemFontOfSize:12];
    placesLabel.backgroundColor = [UIColor clearColor];
    placesLabel.text = @"Recent Places";
    [self.scrollView addSubview:placesLabel];
    self.heightOffset += 20;

    /* Recent Places Scroll View */
    self.placesScrollView = [[[AQGridView alloc] initWithFrame:CGRectMake(0, self.heightOffset, 320, 65)] autorelease];
    self.placesScrollView.layoutDirection = AQGridViewLayoutDirectionHorizontal;
    self.placesScrollView.showsVerticalScrollIndicator = NO;
    self.placesScrollView.showsHorizontalScrollIndicator = NO;
    self.placesScrollView.delegate = self;
    self.placesScrollView.dataSource = self;
    [self.placesScrollView setContentSizeGrowsToFillBounds:NO];
    self.placesScrollView.gridHeaderView.hidden = YES;
    self.placesScrollView.gridFooterView.hidden = YES;
    self.placesScrollView.resizesCellWidthToFit = YES;
    [self.scrollView addSubview:self.placesScrollView];    
    [self.placesScrollView reloadData];
    self.heightOffset += 60;
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

}

- (void) smilesButtonTap
{
    [[ServerInterface sharedManager] updateLocation];
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    NSArray *items = nil;
    if (gridView == self.friendsScrollView) {
        items = self.user.mutualFriends;
    }
    else if (gridView == self.musicScrollView) {
        items = self.user.music;
    }
    else if (gridView == self.placesScrollView) {
        items = self.user.recentPlaces;
    }
    return items.count;
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *nearbyFriendCellIdentifier = @"NearbyFriendCellIdentifier";
    ThumbViewCell *cell = nil;
    cell = (ThumbViewCell *)[gridView dequeueReusableCellWithIdentifier:nearbyFriendCellIdentifier];
    
    if (!cell) {
		cell = [[[ThumbViewCell alloc] initWithFrame:CGRectMake(0, 0, 50, 50)
                                             reuseIdentifier:nearbyFriendCellIdentifier] autorelease];
    }
    
    NSArray *items = nil;
    if (gridView == self.friendsScrollView) {
        items = self.user.mutualFriends;
    }
    else if (gridView == self.musicScrollView) {
        items = self.user.music;
    }
    else if (gridView == self.placesScrollView) {
        items = self.user.recentPlaces;
    }
    
    NSString *itemUrl = [[items objectAtIndex:index] objectForKey:@"thumb"];
    NSString *itemName = [[items objectAtIndex:index] objectForKey:@"name"];

    [cell.imageView setImageWithURL:[NSURL URLWithString:itemUrl]];
    cell.nameLabel.text = itemName;
    
    return cell;
}



- (NSUInteger) gridView: (AQGridView *) gridView willSelectItemAtIndex: (NSUInteger) index
{
    //WWOUser *selectedUser = [self.users objectAtIndex:index];
    //[self userWasSelected:selectedUser];
    return index;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(63, 65) );
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
