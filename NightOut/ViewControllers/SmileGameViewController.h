//
//  SmileGameViewController.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FetchSmileGameRequest.h"
#import "FramedGalleryView.h"
#import "SmileGameChoice.h"
#import "ProfileViewController.h"
#import "GuessSmileGameChoiceRequest.h"

@interface SmileGameViewController : UIViewController <FetchSmileGameRequestDelegate, GuessSmileGameChoiceRequestDelegate, FramedGalleryViewDelegate, ProfileViewControllerDelegate>

@property (nonatomic, retain) FramedGalleryView *gallery;
@property (nonatomic, retain) UILabel *guessesRemainingLabel;
@property (nonatomic, retain) UIView *header;

@property (nonatomic, retain) FetchSmileGameRequest *fetchSmileGameRequest;
@property (nonatomic, retain) GuessSmileGameChoiceRequest *guessSmileGameChoiceRequest;

@property (nonatomic, retain) SmileGame *smileGame;
@property (nonatomic, retain) SmileGameChoice *selectedChoice;

- (void) loadSmileGameFromID:(NSInteger)smileGameID;

@end
