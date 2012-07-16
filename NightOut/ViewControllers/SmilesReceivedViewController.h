//
//  WWOSmilesReceivedViewController.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/20/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "FramedGalleryView.h"
#import "FetchAllSmileGamesRequest.h"

@interface SmilesReceivedViewController : UIViewController <FramedGalleryViewDelegate, FetchSmileGamesRequestDelegate>

@property (retain) IBOutlet FramedGalleryView *gallery;
@property (nonatomic, retain) FetchAllSmileGamesRequest *fetchSmileGamesRequest;
@property (nonatomic, retain) UIView *header;

@end