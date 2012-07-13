//
//  FramedGalleryView.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/12/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "FramedGalleryView.h"
#import "FrameGridViewCell.h"
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

        UIImage *headerImage = [UIImage imageNamed:@"SmilesSentHeader.png"];
        
        UIColor *background = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"WoodBackground.png"]] autorelease];
        
        self.gridView = [[[AQGridView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        self.gridView.showsVerticalScrollIndicator = YES;
        self.gridView.contentSizeGrowsToFillBounds = NO;
        self.gridView.backgroundColor = background;
        
        self.gridView.delegate = self;
        self.gridView.dataSource = self;
        
        [self addSubview:gridView];
        [self.gridView setGridHeaderView: [[[UIImageView alloc] initWithImage:headerImage] autorelease]];
        
        [self addSubview:self.gridView];
    }
    return self;
}

- (AQGridViewCell *) gridView: (AQGridView *) _gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *smilesCellIdentifier = @"SmilesCellIdentifier";
    FrameGridViewCell *cell = nil;
    cell = (FrameGridViewCell *)[_gridView dequeueReusableCellWithIdentifier:smilesCellIdentifier];
    
    if (!cell) {
        cell = [[[FrameGridViewCell alloc] initWithFrame:CGRectMake(0, 0, FRAMED_GALLERY_ITEM_WIDTH, FRAMED_GALLERY_ITEM_HEIGHT) reuseIdentifier:smilesCellIdentifier] autorelease];
    }
    
    [cell updateWithItem:[self.items objectAtIndex:0]];
    
    return cell;
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    //return self.smileGames.count;
    return 30;
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

- (void) reloadData
{
    [self.gridView reloadData];
}

@end
