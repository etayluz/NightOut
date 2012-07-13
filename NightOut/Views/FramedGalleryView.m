//
//  FramedGalleryView.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/12/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "FramedGalleryView.h"
#import "SmilesGridViewCell.h"
#import "SmileGame.h"

@implementation FramedGalleryView

#define FRAMED_GALLERY_ITEM_WIDTH 100
#define FRAMED_GALLERY_ITEM_HEIGHT 100

@synthesize items;
@synthesize gridView;
@synthesize cellReuseID;

- (void) dealloc
{
    self.gridView = nil;
    self.items = nil;
    self.cellReuseID = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.cellReuseID = [self generateUUID];
        self.backgroundColor = [UIColor clearColor];
        self.gridView = [[[AQGridView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        
        self.gridView.backgroundColor = [UIColor clearColor];
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

- (AQGridViewCell *) gridView: (AQGridView *) _gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *smilesCellIdentifier = @"SmilesCellIdentifier";
    SmilesGridViewCell *cell = nil;
    cell = (SmilesGridViewCell *)[_gridView dequeueReusableCellWithIdentifier:smilesCellIdentifier];
    
    if (!cell) {
        cell = [[[SmilesGridViewCell alloc] initWithFrame:CGRectMake(0, 0, FRAMED_GALLERY_ITEM_WIDTH, FRAMED_GALLERY_ITEM_HEIGHT) reuseIdentifier:smilesCellIdentifier] autorelease];
    }
    
    //SmileGame *game = [self.smileGames objectAtIndex:index];
    SmileGame *game = [self.items objectAtIndex:0];
    [cell updateWithUser:game.receiver];
    
    return cell;
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    //return self.smileGames.count;
    return 9;
}



// return a new autoreleased UUID string
- (NSString *)generateUUID
{
    // create a new UUID which you own
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuid = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    
    // transfer ownership of the string
    // to the autorelease pool
    [[uuid retain] autorelease];
    
    // release the UUID
    CFRelease(uuid);
    
    // release the UUIDRef
    CFRelease(uuidRef);
    
    return uuid;
}


- (NSUInteger) gridView: (AQGridView *) gridView willSelectItemAtIndex: (NSUInteger) index
{
    return index;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(FRAMED_GALLERY_ITEM_WIDTH, FRAMED_GALLERY_ITEM_HEIGHT) );
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
