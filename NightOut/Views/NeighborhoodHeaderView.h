//
//  NeighborhoodHeaderView.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/18/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface NeighborhoodHeaderView : UIView

@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) UIImageView *profilePicImageView;

- (void) updateWithUser:(User *)user;

@end
