//
//  WWONearbyViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "WWONearbyViewController.h"
#import "WWONearbyGridViewCellContent.h"

@interface WWONearbyViewController ()

@end

@implementation WWONearbyViewController

@synthesize gridView, cellContentView;

- (void) dealloc
{
    [gridView release];
    [cellContentView release];
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
	// Do any additional setup after loading the view.
    
//    self.gridView = [[[AQGridView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];//    
//    [self.view addSubview: self.gridView];
//    [self.gridView reloadData];
    [self.view reloadData];
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
    AQGridViewCell *cell = nil;
    cell = [_gridView dequeueReusableCellWithIdentifier:nearbyFriendCellIdentifier];
    
    if (!cell) {
		cell = [[[AQGridViewCell alloc] initWithFrame:cellContentView.frame
									  reuseIdentifier:nearbyFriendCellIdentifier] autorelease];
		[cell.contentView addSubview:cellContentView];        
    }
    
    NSArray *colors = [NSArray arrayWithObjects:[UIColor blackColor], [UIColor blackColor], [UIColor redColor], [UIColor blueColor], nil];
    int seed = arc4random()%[colors count];
    cell.contentView.backgroundColor = [colors objectAtIndex:seed];
//    WWONearbyGridViewCellContent *gridViewCell = (WWONearbyGridViewCellContent *) cell;
//    gridViewCell.nameLabel.text = @"Dan";
    
    WWONearbyGridViewCellContent *content = (WWONearbyGridViewCellContent *)[cell.contentView viewWithTag:1];
	content.nameLabel.text = @"Dan";
    content.ageLabel.text = @"24";
    
    
        
    return cell;
}

@end
