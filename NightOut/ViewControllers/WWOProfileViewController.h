//
//  WWOProfileViewController.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/18/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WWOUser.h"

@interface WWOProfileViewController : UIViewController

- (void) updateFromUser:(WWOUser *)user;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;

@end
