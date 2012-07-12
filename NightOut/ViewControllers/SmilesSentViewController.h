//
//  SmilesSentViewController.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "FetchSmileGamesRequest.h"

@interface SmilesSentViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource, FetchSmileGamesRequestDelegate>

@property (retain) IBOutlet AQGridView *gridView;
@property (nonatomic, retain) UIImageView *headerView;

@property (nonatomic, retain) FetchSmileGamesRequest *fetchSmileGamesRequest;
@property (nonatomic, retain) NSMutableArray *smileGames;

@end
