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

@interface SmileGameViewController : UIViewController <FetchSmileGameRequestDelegate, FramedGalleryViewDelegate>

@property (nonatomic, retain) FramedGalleryView *gallery;
@property (nonatomic, retain) FetchSmileGameRequest *fetchSmileGameRequest;

- (void) loadSmileGameFromID:(NSInteger)smileGameID;

@end
