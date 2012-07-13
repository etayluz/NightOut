//
//  SmilesView.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/25/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "SmilesGridViewCell.h"
#import "UIImageView+ScaledImage.h"

@implementation SmilesGridViewCell
@synthesize imageView, nameLabel, ageLabel, networkLabel, imageMask;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        /* Image View */
        UIImage *pic = [UIImage imageNamed:@"header.png"];
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 78, 78)] autorelease];
        [self.imageView setImage:pic];
        [self.contentView addSubview: self.imageView];
        
        /* Image Mask */
        self.imageMask = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 88, 110)] autorelease];
        [self.imageMask setImage:[UIImage imageNamed:@"PictureFrameMask-2.png"]];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview: self.imageMask];

        
        /* Name Label */
        self.nameLabel                  = [[[UILabel alloc] initWithFrame:CGRectMake(7, 90, 100, 18)] autorelease];
//        self.nameLabel.font              = [UIFont boldSystemFontOfSize:10];
        self.nameLabel.backgroundColor   = [UIColor clearColor];
        self.nameLabel.text = @"Venkat";
        self.nameLabel.font = [UIFont fontWithName:@"Myriad Pro" size:16];
        self.nameLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview: self.nameLabel];
        
        /* Age Label */
        self.ageLabel                   = [[[UILabel alloc] initWithFrame:CGRectMake(70, 89, 100, 15)] autorelease];
//        self.ageLabel.font              = [UIFont boldSystemFontOfSize:10];
        self.ageLabel.backgroundColor   = [UIColor clearColor];
        self.ageLabel.text = @"25";
        self.ageLabel.font = [UIFont fontWithName:@"Myriad" size:15];
        self.ageLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview: self.ageLabel];
        
        /* Network Label */
        self.networkLabel                   = [[[UILabel alloc] initWithFrame:CGRectMake(7, 102, 100, 15)] autorelease];
//        self.networkLabel.font              = [UIFont boldSystemFontOfSize:10];
        self.networkLabel.backgroundColor   = [UIColor clearColor];
        self.networkLabel.text = @"Stanford";
        self.networkLabel.font = [UIFont fontWithName:@"Myriad" size:13];
        self.networkLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview: self.networkLabel];
        
        //self.contentView.transform =  CGAffineTransformMakeRotation(M_PI/8);
    }

    return self;
}

- (void) updateWithUser:(User *)user
{
    self.nameLabel.text = user.name;
    self.networkLabel.text = user.network;
    self.ageLabel.text = [user.age stringValue];
    [self.imageView setImageWithURLScaled:user.thumb];
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
