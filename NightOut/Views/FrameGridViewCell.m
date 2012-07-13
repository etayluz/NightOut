//
//  SmilesView.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/25/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "FrameGridViewCell.h"
#import "UIImageView+ScaledImage.h"
#import "SmileGame.h"

@implementation FrameGridViewCell

@synthesize imageView, imageMask;
@synthesize titleLabel, subtitleLabel, rightLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        /* Image View */
        UIImage *pic = [UIImage imageNamed:@"header.png"];
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)] autorelease];
        [self.imageView setImage:pic];
        [self.contentView addSubview: self.imageView];
        
        /* Image Mask */
        self.imageMask = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 100)] autorelease];
        [self.imageMask setImage:[UIImage imageNamed:@"PictureFrameMask-2.png"]];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview: self.imageMask];
        
        /* Name Label */
        self.titleLabel                  = [[[UILabel alloc] initWithFrame:CGRectMake(10, 70, 100, 15)] autorelease];
        self.titleLabel.font              = [UIFont boldSystemFontOfSize:10];
        self.titleLabel.backgroundColor   = [UIColor clearColor];
        self.titleLabel.text = @"-";
        [self addSubview: self.titleLabel];
        
        /* Age Label */    
        self.rightLabel                   = [[[UILabel alloc] initWithFrame:CGRectMake(55, 70, 100, 15)] autorelease];
        self.rightLabel.font              = [UIFont boldSystemFontOfSize:10];
        self.rightLabel.backgroundColor   = [UIColor clearColor];
        self.rightLabel.text = @"-";
        [self addSubview: self.rightLabel];
        
        /* Network Label */
        self.subtitleLabel                   = [[[UILabel alloc] initWithFrame:CGRectMake(10, 80, 100, 15)] autorelease];
        self.subtitleLabel.font              = [UIFont boldSystemFontOfSize:10];
        self.subtitleLabel.backgroundColor   = [UIColor clearColor];
        self.subtitleLabel.text = @"-";
        [self addSubview: self.subtitleLabel];
    }

    return self;
}

- (void) updateWithItem:(NSObject *)item
{
    SmileGame *game = (SmileGame *)item;
    [self.imageView setImageWithURLScaled:game.receiver.thumb];
    
    self.titleLabel.text = game.receiver.name;
    self.subtitleLabel.text = game.receiver.network;
    self.rightLabel.text = [game.receiver.age stringValue];
}

@end
