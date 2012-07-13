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
@synthesize imageView, imageMask, overlay;

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
    }

    return self;
}

- (void) updateWithItem:(NSObject *)item
{
    SmileGame *game = (SmileGame *)item;
    [self.imageView setImageWithURLScaled:game.receiver.thumb];
}

@end
