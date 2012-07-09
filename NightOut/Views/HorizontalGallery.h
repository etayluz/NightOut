//
//  HorizontalGallery.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/5/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface HorizontalGallery : UIView <AQGridViewDelegate, AQGridViewDataSource>

@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain)  AQGridView *gridView;
@property (nonatomic, retain) NSString *cellReuseID;

- (void) reloadData;

@end
