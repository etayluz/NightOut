//
//  WWONearbyViewController.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@class WWONearbyGridViewCellContent;
@interface WWONearbyViewController : UIViewController<AQGridViewDelegate, AQGridViewDataSource>

@property (retain) AQGridView *gridView;
@property (nonatomic, retain) IBOutlet WWONearbyGridViewCellContent *cellContentView;

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView;
- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index;
@end
