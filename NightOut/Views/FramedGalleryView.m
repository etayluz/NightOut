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

#define FRAMED_GALLERY_ITEM_WIDTH 90
#define FRAMED_GALLERY_ITEM_HEIGHT 120

@synthesize items;
@synthesize gridView;
@synthesize cellReuseID;
@synthesize delegate;
@synthesize frameStyle, topPadding;

- (void) dealloc
{
    self.gridView = nil;
    self.items = nil;
    self.cellReuseID = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:FrameGridViewCellStyleBasic];
}

- (id)initWithFrame:(CGRect)frame style:(FrameGridViewCellStyle)aStyle
{
    self = [super initWithFrame:frame];
    if (self) {        
        self.cellReuseID = [self generateUUID];
        self.backgroundColor = [UIColor clearColor];
        self.frameStyle = aStyle;
        
        UIColor *background = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"WoodBG.png"]] autorelease];
        
        self.gridView = [[[AQGridView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        self.gridView.showsVerticalScrollIndicator = YES;
        self.gridView.contentSizeGrowsToFillBounds = NO;
        self.gridView.backgroundColor = background;
        self.gridView.delegate = self;
        self.gridView.dataSource = self;
                
        [self addSubview:self.gridView];
    }
    return self;
}

- (void) setTopPadding:(NSInteger)_topPadding
{
    [self.gridView.gridHeaderView removeFromSuperview];
    UIView *emptyHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _topPadding)];
    self.gridView.gridHeaderView = emptyHeaderView;
    
    topPadding = _topPadding;
}

- (AQGridViewCell *) gridView: (AQGridView *) _gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *smilesCellIdentifier = @"SmilesCellIdentifier";
    FrameGridViewCell *cell = nil;
    cell = (FrameGridViewCell *)[_gridView dequeueReusableCellWithIdentifier:smilesCellIdentifier];
    
    if (!cell) {
        cell = [[[FrameGridViewCell alloc] initWithFrame:CGRectMake(0, 0, FRAMED_GALLERY_ITEM_WIDTH, FRAMED_GALLERY_ITEM_HEIGHT) reuseIdentifier:smilesCellIdentifier style:self.frameStyle] autorelease];
    }
    
    [self.delegate updateCell:cell fromItem:[self.items objectAtIndex:index]];
    
    return cell;
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return self.items.count;
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
    NSObject *item = [self.items objectAtIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(didSelectItem:)]) 
        [self.delegate didSelectItem:item];
    
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
