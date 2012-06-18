//
//  WWONearbyGridViewCell.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "AQGridViewCell.h"
#import "WWOUser.h"

@interface WWONearbyGridViewCell : AQGridViewCell

- (void) updateFromUser:(WWOUser *) user;


@property (nonatomic, retain)  UIImageView *imageView;
@property (nonatomic, retain)  UILabel *nameLabel;
@property (nonatomic, retain)  UILabel *ageLabel;

@end
