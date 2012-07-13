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

@interface FrameGridViewCell : AQGridViewCell

@property (nonatomic, retain)  UIImageView  *imageMask;
@property (nonatomic, retain)  UIImageView  *imageView;

@property (nonatomic, retain)  UILabel      *titleLabel;
@property (nonatomic, retain)  UILabel      *subtitleLabel;
@property (nonatomic, retain)  UILabel      *rightLabel;

@end
