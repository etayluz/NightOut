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

@synthesize nameLabel, ageLabel, networkLabel, friendsLabel, profileImageView, horizontalScrollView;

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
    self.friendsLabel.text = [NSString stringWithFormat:@"Myfriends(%@)", [user.age stringValue]];
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

    /* Image Label */
    self.profileImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 280)] autorelease];

    /* Name Label */
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 280, 100, 21)];
    self.nameLabel.font            = [UIFont boldSystemFontOfSize:15];
    self.nameLabel.backgroundColor = [UIColor clearColor];

    /* Age Label */
    self.ageLabel = [[UILabel alloc] init];
    self.ageLabel.font            = [UIFont boldSystemFontOfSize:13];
    self.ageLabel.backgroundColor = [UIColor clearColor];
 
    /* Separator Label */
    UILabel *separator = [[UILabel alloc] initWithFrame:CGRectMake(5, 290, 320, 21)];
    separator.font            = [UIFont boldSystemFontOfSize:12];
    separator.backgroundColor = [UIColor clearColor];
    separator.text = @"_____________________________________________";

    /* Friends Label */
    self.friendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 310, 100, 21)];
    self.friendsLabel.font            = [UIFont boldSystemFontOfSize:12];
    self.friendsLabel.backgroundColor = [UIColor clearColor];
    
    /* Friends Horizontal Scroll View */
    self.horizontalScrollView  = [[GMGridView alloc] initWithFrame:CGRectMake(5, 290, 320, 20)];
    self.horizontalScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.horizontalScrollView.style = GMGridViewStylePush;
    self.horizontalScrollView.itemSpacing = 5;
    self.horizontalScrollView.minEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2);
    //self.horizontalScrollView.
    self.horizontalScrollView.centerGrid = NO;
    self.horizontalScrollView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontal];
    self.horizontalScrollView.showsHorizontalScrollIndicator = NO;
    self.horizontalScrollView.showsVerticalScrollIndicator = NO;
    CGRect frame = CGRectMake(0, 330, 320, 20);
    self.horizontalScrollView.frame = frame; 
    self.horizontalScrollView.transformDelegate = self;
    self.horizontalScrollView.dataSource = self;
    self.horizontalScrollView.mainSuperView = self.view;

    [scrollView addSubview:self.profileImageView];
    [scrollView addSubview:self.nameLabel]; 
    [scrollView addSubview:self.ageLabel]; 
    [scrollView addSubview:self.friendsLabel];
    [scrollView addSubview:separator];
    [scrollView addSubview:self.horizontalScrollView];    
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
        return CGSizeMake(50, 50);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) 
    {
        cell = [[GMGridViewCell alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor greenColor];
        view.layer.masksToBounds = NO;
        //view.layer.cornerRadius = 8;
        //view.layer.shadowColor = [UIColor grayColor].CGColor;
        //view.layer.shadowOffset = CGSizeMake(5, 5);
        //view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
        //view.layer.shadowRadius = 8;
        
        cell.contentView = view;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.text = [NSString stringWithFormat:@"%d", index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [cell.contentView addSubview:label];
    
    return cell;
}

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return 10;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    CGSize viewSize = self.view.bounds.size;
    return CGSizeMake(viewSize.width - 50, viewSize.height - 50);
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    UIView *fullView = [[UIView alloc] init];
    fullView.backgroundColor = [UIColor yellowColor];
    fullView.layer.masksToBounds = NO;
    fullView.layer.cornerRadius = 8;
    
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %d", index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    label.font = [UIFont boldSystemFontOfSize:15];
    
    
    [fullView addSubview:label];
    
    
    return fullView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
@end
