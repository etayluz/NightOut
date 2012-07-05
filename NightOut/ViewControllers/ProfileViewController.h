//
//  WWOProfileViewController.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/18/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <QuartzCore/QuartzCore.h>
#import "User.h"
#import "AQGridView.h"
#import "FetchUserRequest.h"
#import "ScaledImageView.h"

#define OFFSET_FROM_NAME_LABEL     30

@interface ProfileViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource, FetchUserRequestDelegate>

- (void) updateFromUserID:(NSInteger)userID;
- (void) updateFromUser:(User *)user;
- (void) messageButtonTap;
- (void) smilesButtonTap;

@property (nonatomic, retain) User *user;

@property (nonatomic, retain)  UILabel *nameLabel;
@property (nonatomic, retain)  UILabel *ageLabel;
@property (nonatomic, retain)  UILabel *friendsLabel;
@property (nonatomic, retain)  UILabel *networkLabel;
@property (nonatomic, retain)  ScaledImageView *profileImageView;
@property (nonatomic, retain)  AQGridView *friendsScrollView;
@property (nonatomic, retain)  AQGridView *interestsScrollView;
@property (nonatomic, retain)  UIButton *messageButton;
@property (nonatomic, retain)  UIButton *smileButton;
@property (nonatomic, retain)  UIScrollView *scrollView;

@property (nonatomic, retain) NSMutableDictionary *infoValueLabels;


@property (nonatomic)  NSInteger heightOffset;
@end