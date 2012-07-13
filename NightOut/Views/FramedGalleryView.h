//
//  FramedGalleryView.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/12/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "FrameGridViewCell.h"

@protocol FramedGalleryViewDelegate

- (void) updateCell:(FrameGridViewCell *)cell fromItem:(NSObject *)item;

@end

@interface FramedGalleryView : UIView <AQGridViewDelegate, AQGridViewDataSource>

@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain)  AQGridView *gridView;
@property (nonatomic, retain) NSString *cellReuseID;

@property (assign) id <FramedGalleryViewDelegate> delegate;

- (void) reloadData;

@end
