//
//  HorizontalGallery.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/5/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "HorizontalGallery.h"
#import "ThumbViewCell.h"
#import "UIImageView+WebCache.h"

@implementation HorizontalGallery

@synthesize items;
@synthesize gridView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.gridView = [[[AQGridView alloc] initWithFrame:frame] autorelease];
        self.gridView.backgroundColor = [UIColor yellowColor];
        self.gridView.layoutDirection = AQGridViewLayoutDirectionHorizontal;
        self.gridView.showsVerticalScrollIndicator = NO;
        self.gridView.showsHorizontalScrollIndicator = NO;
        self.gridView.delegate = self;
        self.gridView.dataSource = self;
        [self.gridView setContentSizeGrowsToFillBounds:NO];
        self.gridView.gridHeaderView.hidden = YES;
        self.gridView.gridFooterView.hidden = YES;  
        self.gridView.resizesCellWidthToFit = YES;
        
    }
    return self;
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    // todo: make identifier unique
    static NSString *nearbyFriendCellIdentifier = @"NearbyFriendCellIdentifier";
    
    ThumbViewCell *cell = nil;
    cell = (ThumbViewCell *)[self.gridView dequeueReusableCellWithIdentifier:nearbyFriendCellIdentifier];
    
    if (!cell) {
		cell = [[[ThumbViewCell alloc] initWithFrame:CGRectMake(0, 0, 90, 120)
                                     reuseIdentifier:nearbyFriendCellIdentifier] autorelease];
    }
    
    NSString *itemUrl = [[self.items objectAtIndex:index] objectForKey:@"thumb"];
    NSString *itemName = [[self.items objectAtIndex:index] objectForKey:@"name"];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:itemUrl]];
    cell.nameLabel.text = itemName;
    
    return cell;
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return self.items.count;
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

- (void) reloadData
{
    [self.gridView reloadData];
}

@end
