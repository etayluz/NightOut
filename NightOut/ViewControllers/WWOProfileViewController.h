//
//  WWOProfileViewController.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/18/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <QuartzCore/QuartzCore.h>
#import "WWOUser.h"
#import "GMGridView.h"
#import "GMGridViewLayoutStrategies.h"

#define OFFSET_FROM_NAME_LABEL     30

@interface WWOProfileViewController : UIViewController <GMGridViewDataSource, GMGridViewTransformationDelegate>

- (void) updateFromUser:(WWOUser *)user;

@property (nonatomic, retain)  UILabel *nameLabel;
@property (nonatomic, retain)  UILabel *ageLabel;
@property (nonatomic, retain)  UILabel *friendsLabel;
@property (nonatomic, retain)  UILabel *networkLabel;
@property (nonatomic, retain)  UIImageView *profileImageView;
@property (nonatomic, retain)  GMGridView *horizontalScrollView;

@end