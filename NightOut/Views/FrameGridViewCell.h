//
//  SmilesView.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/25/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridViewCell.h"
#import "User.h"
#import "UserFrameOverlay.h"

@interface FrameGridViewCell : AQGridViewCell
@property (nonatomic, retain)  UIImageView  *imageMask;
@property (nonatomic, retain)  UIImageView  *imageView;
@property (nonatomic, retain) UIView *overlay;

- (void) updateWithItem:(NSObject *)item;

@end
