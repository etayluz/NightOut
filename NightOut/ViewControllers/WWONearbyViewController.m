//
//  WWONearbyViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "WWONearbyViewController.h"
#import "WWONearbyGridViewCell.h"
#import "UIImageView+WebCache.h"

@interface WWONearbyViewController ()
@end

@implementation WWONearbyViewController

@synthesize gridView;
@synthesize headerView;

- (void) dealloc
{
    [gridView release];
    [headerView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *headerImage = [UIImage imageNamed:@"header.png"];
    [self.gridView setGridHeaderView: [[[UIImageView alloc] initWithImage:headerImage] autorelease]];
    
    [self.gridView reloadData];
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

#pragma mark data source implementation
- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return 2;
}

- (AQGridViewCell *) gridView: (AQGridView *) _gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *nearbyFriendCellIdentifier = @"NearbyFriendCellIdentifier";
    WWONearbyGridViewCell *cell = nil;
    cell = (WWONearbyGridViewCell *)[_gridView dequeueReusableCellWithIdentifier:nearbyFriendCellIdentifier];
    
    if (!cell) {
		cell = [[[WWONearbyGridViewCell alloc] initWithFrame:CGRectMake(0, 0, 94, 140)
									  reuseIdentifier:nearbyFriendCellIdentifier] autorelease];   
    }
    
    NSArray *colors = [NSArray arrayWithObjects:[UIColor blackColor], [UIColor blackColor], [UIColor redColor], [UIColor blueColor], nil];
    int seed = arc4random()%[colors count];
    cell.contentView.backgroundColor = [colors objectAtIndex:seed];
    cell.nameLabel.text = @"Dan";
    cell.ageLabel.text = @"24";
    [cell.imageView setImageWithURL:[NSURL URLWithString:@"http://nightapi.pagodabox.com/images/venkat.png"]];
    
    
        
    return cell;
}

@end
