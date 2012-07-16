//
//  SmilesSentViewController.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

#import "FramedGalleryView.h"
#import "FetchAllSmileGamesRequest.h"

@interface SmilesSentViewController : UIViewController <FetchSmileGamesRequestDelegate, FramedGalleryViewDelegate>

@property (nonatomic, retain) FramedGalleryView *gallery;
@property (nonatomic, retain) FetchAllSmileGamesRequest *fetchSmileGamesRequest;
@property (nonatomic, retain) UIView *header;

@end
