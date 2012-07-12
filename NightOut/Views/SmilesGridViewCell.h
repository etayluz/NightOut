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

@interface SmilesGridViewCell : AQGridViewCell
@property (nonatomic, retain)  UIImageView  *imageMask;
@property (nonatomic, retain)  UIImageView  *imageView;
@property (nonatomic, retain)  UILabel      *nameLabel;
@property (nonatomic, retain)  UILabel      *ageLabel;
@property (nonatomic, retain)  UILabel      *networkLabel;

- (void) updateWithUser:(User *)user;

@end
