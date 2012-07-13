//
//  FramedGalleryView.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/12/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface FramedGalleryView : UIView <AQGridViewDelegate, AQGridViewDataSource>
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain)  AQGridView *gridView;
@property (nonatomic, retain) NSString *cellReuseID;

- (void) reloadData;

@end
