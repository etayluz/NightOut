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
#import "FetchSmileGamesRequest.h"

@interface SmilesReceivedViewController : UIViewController <FetchSmileGamesRequestDelegate>

@property (retain) IBOutlet FramedGalleryView *gallery;
@property (nonatomic, retain) FetchSmileGamesRequest *fetchSmileGamesRequest;

@end