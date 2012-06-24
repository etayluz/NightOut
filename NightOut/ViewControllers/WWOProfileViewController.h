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
#import "AQGridView.h"

#define OFFSET_FROM_NAME_LABEL     30

@interface WWOProfileViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource>

- (void) updateFromUser:(WWOUser *)user;
- (void) messageButtontap;
- (void) smilesButtontap;

@property (nonatomic, retain)  UILabel *nameLabel;
@property (nonatomic, retain)  UILabel *ageLabel;
@property (nonatomic, retain)  UILabel *friendsLabel;
@property (nonatomic, retain)  UILabel *networkLabel;
@property (nonatomic, retain)  UIImageView *profileImageView;
@property (nonatomic, retain)  AQGridView *friendsScrollView;
@property (nonatomic, retain)  AQGridView *musicScrollView;
@property (nonatomic, retain)  AQGridView *placesScrollView;
@property (nonatomic, retain)  UIButton *messageButton;
@property (nonatomic, retain)  UIButton *smileButton;
@property (nonatomic, retain)  UIScrollView *scrollView;

@property (nonatomic, retain)  UILabel *hometownLabel;
@property (nonatomic, retain)  UILabel *currentCityLabel;
@property (nonatomic, retain)  UILabel *collegeLabel;
@property (nonatomic, retain)  UILabel *interestedInLabel;
@property (nonatomic, retain)  UILabel *relationshipStatusLabel;
@property (nonatomic, retain)  UILabel *workLabel;

@property (nonatomic, retain)  UILabel *hometownValueLabel;
@property (nonatomic, retain)  UILabel *currentCityValueLabel;
@property (nonatomic, retain)  UILabel *collegeValueLabel;
@property (nonatomic, retain)  UILabel *interestedInValueLabel;
@property (nonatomic, retain)  UILabel *relationshipStatusValueLabel;
@property (nonatomic, retain)  UILabel *workValueLabel;

@property (nonatomic, retain) NSMutableDictionary *infoLabels;
@property (nonatomic, retain) NSMutableDictionary *infoValueLabels;


@property (nonatomic)  NSInteger heightOffset;
@end