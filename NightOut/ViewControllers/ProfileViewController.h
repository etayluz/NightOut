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

#import "FetchUserRequest.h"
#import "StartSmileGameRequest.h"

#import "HorizontalGallery.h"
#import "LayoutManagers.h"

#define OFFSET_FROM_NAME_LABEL     30

typedef enum {
    ProfileViewStyleFull,
    ProfileViewStyleSelf,
    ProfileViewStyleChoose
} ProfileViewStyle;

@interface ProfileViewController : UIViewController <FetchUserRequestDelegate, StartSmileGameRequestDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

- (void) loadFromUserID:(NSInteger)userID;
- (void) loadFromUser:(User *)user;
- (void) loadCurrentUser;
- (void) messageButtonTap;
- (void) smilesButtonTap;
- (id) initWithStyle:(ProfileViewStyle)_style;

@property (nonatomic, retain) StartSmileGameRequest *startSmileGameRequest;

@property (nonatomic, retain) User *user;

@property (nonatomic, retain)  UILabel *nameLabel;
@property (nonatomic, retain)  UILabel *ageLabel;
@property (nonatomic, retain)  UIImageView *profileImageView;

@property (nonatomic, retain)  HorizontalGallery *mutualFriendsView;
@property (nonatomic, retain)  HorizontalGallery *interestsView;

@property (nonatomic, retain)  UIButton *messageButton;
@property (nonatomic, retain)  UIButton *smileButton;
@property (nonatomic, retain)  UIScrollView *scrollView;

@property (nonatomic, retain) NSMutableDictionary *infoValueLabels;
@property (nonatomic) ProfileViewStyle style;
@property (nonatomic)  NSInteger heightOffset;

@property (nonatomic, retain) UIView *chooseFooter;
@property (nonatomic, retain) UIButton *chooseButton;

@property (nonatomic) BOOL fetchCurrentUserOnLoad;

@end
