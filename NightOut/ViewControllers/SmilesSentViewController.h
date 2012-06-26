//
//  SmilesSentViewController.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface SmilesSentViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource>

@property (retain) IBOutlet AQGridView *gridView;
@property (nonatomic, retain) UIImageView *headerView;

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView;
- (AQGridViewCell *) gridView: (AQGridView *) _gridView cellForItemAtIndex: (NSUInteger) index;
@end
