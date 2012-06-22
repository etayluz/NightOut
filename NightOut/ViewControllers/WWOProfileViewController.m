//
//  WWOProfileViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/18/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "WWOProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "ThumbViewCell.h"
#import "WWOUser.h"

@interface WWOProfileViewController ()
@property (nonatomic, retain) NSArray *users;

@end

@implementation WWOProfileViewController

@synthesize scrollView, nameLabel, ageLabel, networkLabel, friendsLabel, profileImageView;
@synthesize friendsScrollView, musicScrollView, placesScrollView, users, messageButton, smileButton, heightOffset;

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
    
    /* Friends Label */
    self.friendsLabel.text = [NSString stringWithFormat:@"Mutual friends(%@)", [user.age stringValue]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)] autorelease];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320, 1000);
    [self.view addSubview:self.scrollView];

    /* Image Label */
    self.profileImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 280)] autorelease];
    [self.scrollView addSubview:self.profileImageView];
    self.heightOffset += 280;

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
    [self.messageButton addTarget:self action:@selector(messageButtonTap:) forControlEvents:UIControlEventTouchDown];
    [self.messageButton setTitle: @"Message" forState: UIControlStateNormal];
    self.messageButton.frame = CGRectMake(5, self.heightOffset, 300, 30);
    [self.scrollView addSubview:self.messageButton];
    self.heightOffset += 35;

    /* Smiles Button */
    self.smileButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [self.smileButton addTarget:self action:@selector(smilesButtonTap:) forControlEvents:UIControlEventTouchDown];
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
    self.heightOffset += 60;}

- (void) generalInfo
{
    /* General Info Label */
    UILabel *generalInfoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, self.heightOffset, 100, 21)] autorelease];
    generalInfoLabel.font            = [UIFont boldSystemFontOfSize:12];
    generalInfoLabel.backgroundColor = [UIColor clearColor];
    generalInfoLabel.text = @"General Info";
    [self.scrollView addSubview:generalInfoLabel];
    self.heightOffset += 20;

    NSArray *labelArray = [NSArray arrayWithObjects:
                      @"Hometown", @"Current city", @"College", @"Interested in", @"Relationship status", @"Work", nil];

    for (NSString *element in labelArray) {
        UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, self.heightOffset, 100, 21)] autorelease];
        infoLabel.font = [UIFont boldSystemFontOfSize:10];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.text = element;
        [self.scrollView addSubview:infoLabel];
        self.heightOffset += 15;
    }
    



}

- (void) messageButtontap
{

}

- (void) smilesButtontap
{
    
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    //return self.users.count;
    return 150;
}

- (AQGridViewCell *) gridView: (AQGridView *) _gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *nearbyFriendCellIdentifier = @"NearbyFriendCellIdentifier";
    ThumbViewCell *cell = nil;
    cell = (ThumbViewCell *)[_gridView dequeueReusableCellWithIdentifier:nearbyFriendCellIdentifier];
    
    if (!cell) {
		cell = [[[ThumbViewCell alloc] initWithFrame:CGRectMake(0, 0, 50, 50)
                                             reuseIdentifier:nearbyFriendCellIdentifier] autorelease];
    }
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:@"http://nightapi.pagodabox.com/images/venkat.png"]];
    cell.nameLabel.text = @"ven";
    
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
@end
