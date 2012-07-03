//
//  WWONearbyGridViewCell.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "NearbyGridViewCell.h"
#import "UIImageView+WebCache.h"

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

        /* Image Label */
        self.backgroundColor = [UIColor purpleColor];
        self.contentView.backgroundColor = [UIColor grayColor];
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];

        /* Name Label */
        self.nameLabel                  = [[[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 15)] autorelease];
        self.nameLabel.font             = [UIFont boldSystemFontOfSize:13];
        self.nameLabel.backgroundColor  = [UIColor clearColor];

        /* Age Label */
        self.ageLabel                   = [[[UILabel alloc] initWithFrame:CGRectMake(80, 100, 100, 15)] autorelease];
        self.ageLabel.font              = [UIFont boldSystemFontOfSize:13];
        self.ageLabel.backgroundColor   = [UIColor clearColor];

        /* Friends Label */
        self.friendsLabel                  = [[[UILabel alloc] initWithFrame:CGRectMake(0, 115, 100, 15)] autorelease];
        self.friendsLabel.font             = [UIFont boldSystemFontOfSize:10];
        self.friendsLabel.backgroundColor  = [UIColor clearColor];

        /* Network Label */
        self.networkLabel                  = [[[UILabel alloc] initWithFrame:CGRectMake(0, 130, 100, 15)] autorelease];
        self.networkLabel.font             = [UIFont boldSystemFontOfSize:10];
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
    [self.imageView setImageWithURL:[NSURL URLWithString:user.thumb]];
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
