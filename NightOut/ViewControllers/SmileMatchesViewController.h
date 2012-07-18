//
//  MatchesViewController.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/17/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FramedGalleryView.h"
#import "FetchAllSmileGamesRequest.h"

@interface SmileMatchesViewController : UIViewController <FramedGalleryViewDelegate, FetchSmileGamesRequestDelegate>

@property (nonatomic, retain) FramedGalleryView *gallery;
@property (nonatomic, retain) UIView *header;
@property (nonatomic, retain) UILabel *smileMatchesCountLabel;

@property (nonatomic, retain) FetchAllSmileGamesRequest *fetchSmileGamesRequest;

@end
