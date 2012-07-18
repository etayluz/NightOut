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
#import "GradientButton.h"

#define OFFSET_FROM_NAME_LABEL     30

@protocol ProfileViewControllerDelegate <NSObject>
- (void) didTapChooseButton;
@end

@interface ProfileViewController : UIViewController <FetchUserRequestDelegate, StartSmileGameRequestDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

- (void) loadFromUserID:(NSInteger)userID;
- (void) loadFromUser:(User *)user;
- (void) loadCurrentUser;
- (void) messageButtonTap;
- (void) smilesButtonTap;

@property (assign) id <ProfileViewControllerDelegate> delegate;

@property (nonatomic) BOOL fetchCurrentUserOnLoad;
@property (nonatomic) BOOL autoUpdateTitle;

@property (nonatomic) BOOL hideSmileAndMessageButtons;
@property (nonatomic) BOOL hideMutualFriends;
@property (nonatomic) BOOL showChooseButton;

@property (nonatomic, retain) UIView *chooseFooter;
@property (nonatomic, retain) GradientButton *chooseButton;

@end
