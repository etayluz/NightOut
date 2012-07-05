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

#define HORIZONTAL_GALLERY_ITEM_WIDTH 90
#define HORIZONTAL_GALLERY_ITEM_HEIGHT 120

@implementation HorizontalGallery

@synthesize items;
@synthesize gridView;

- (void) dealloc
{
    self.gridView = nil;
    self.items = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.gridView = [[[AQGridView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
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
        
        [self addSubview:self.gridView];
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
		cell = [[[ThumbViewCell alloc] initWithFrame:CGRectMake(0, 0, HORIZONTAL_GALLERY_ITEM_WIDTH, HORIZONTAL_GALLERY_ITEM_HEIGHT)
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
    return ( CGSizeMake(HORIZONTAL_GALLERY_ITEM_WIDTH, HORIZONTAL_GALLERY_ITEM_HEIGHT) );
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
