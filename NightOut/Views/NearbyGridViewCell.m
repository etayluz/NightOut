//
//  WWONearbyGridViewCell.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "NearbyGridViewCell.h"
#import "ScaledImageView.h"
#import "User.h"

@implementation NearbyGridViewCell
@synthesize imageView, nameLabel, ageLabel, networkLabel, friendsLabel;

- (void) dealloc
{
    NSLog(@"deallocated");
    self.imageView = nil;
    self.nameLabel = nil;
    self.ageLabel = nil;
    self.friendsLabel = nil;
    self.networkLabel = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = AQGridViewCellSelectionStyleNone;
        
        /* Image Label */
        self.backgroundColor = [UIColor purpleColor];
//        self.contentView.backgroundColor = [UIColor grayColor];
        self.contentView.backgroundColor = [UIColor colorWithRed:0.929 green:0.933 blue:0.863 alpha:1];
        self.imageView = [[[ScaledImageView alloc] initWithFrame:CGRectMake(10, 20, 90, 90)] autorelease];

        /* Name Label */
        self.nameLabel                  = [[[UILabel alloc] initWithFrame:CGRectMake(10, 113, 100, 20)] autorelease];
//        self.nameLabel.font             = [UIFont boldSystemFontOfSize:13];
        self.nameLabel.font = [UIFont fontWithName:@"Myriad Pro" size:17];
        self.nameLabel.textColor = [UIColor darkGrayColor];
        self.nameLabel.backgroundColor  = [UIColor clearColor];

        /* Age Label */
        self.ageLabel                   = [[[UILabel alloc] initWithFrame:CGRectMake(88, 113, 100, 15)] autorelease];
//        self.ageLabel.font              = [UIFont boldSystemFontOfSize:13];
        self.ageLabel.font = [UIFont fontWithName:@"Myriad" size:16];
        self.ageLabel.textColor = [UIColor grayColor];
        self.ageLabel.backgroundColor   = [UIColor clearColor];

        /* Friends Label */
        self.friendsLabel                  = [[[UILabel alloc] initWithFrame:CGRectMake(10, 130, 100, 15)] autorelease];
//        self.friendsLabel.font             = [UIFont boldSystemFontOfSize:10];
        self.friendsLabel.font = [UIFont fontWithName:@"Myriad" size:13];
        self.friendsLabel.textColor = [UIColor grayColor];
        self.friendsLabel.backgroundColor  = [UIColor clearColor];

        /* Network Label */
        self.networkLabel                  = [[[UILabel alloc] initWithFrame:CGRectMake(10, 144, 100, 15)] autorelease];
//        self.networkLabel.font             = [UIFont boldSystemFontOfSize:10];
        self.networkLabel.font = [UIFont fontWithName:@"Myriad" size:13];
        self.networkLabel.textColor = [UIColor grayColor];
        self.networkLabel.backgroundColor  = [UIColor clearColor];

        [self.contentView addSubview:imageView];
        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:ageLabel];
        [self.contentView addSubview:networkLabel];
        [self.contentView addSubview:friendsLabel];

    }
    return self;
}

- (void) updateFromUser:(User *) user
{
    self.nameLabel.text = user.name;
    self.ageLabel.text = [user.age stringValue];
    //TODO: friends
    //self.friendsLabel.text = [NSString stringWithFormat:@"Mutual Friends: %@", [user.friends stringValue]];
    self.friendsLabel.text = @"Mutual Friends: 13";   
    self.networkLabel.text = user.network;
    
    [self.imageView setUrl:user.thumb];
}

- (CALayer *) glowSelectionLayer
{
    return self.layer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
