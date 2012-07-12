//
//  WWONearbyGridViewCell.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "AQGridViewCell.h"
#import "User.h"

@interface NearbyGridViewCell : AQGridViewCell

- (void) updateFromUser:(User *) user;


@property (nonatomic, retain)  UIImageView  *imageView;
@property (nonatomic, retain)  UILabel      *nameLabel;
@property (nonatomic, retain)  UILabel      *ageLabel;
@property (nonatomic, retain)  UILabel      *networkLabel;
@property (nonatomic, retain)  UILabel      *friendsLabel;

@end
