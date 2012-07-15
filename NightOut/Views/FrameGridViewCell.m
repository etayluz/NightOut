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
@synthesize style;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithFrame:frame reuseIdentifier:reuseIdentifier style:FrameGridViewCellStyleBasic];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier style:(FrameGridViewCellStyle) aStyle
{
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {        
        self.selectionStyle = AQGridViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        
        /* Image View */
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 78, 78)] autorelease];
        [self.contentView addSubview: self.imageView];
        
        /* Image Mask */
        self.imageMask = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 88, 110)] autorelease];
        [self.imageMask setImage:[UIImage imageNamed:@"PictureFrameMask-2.png"]];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview: self.imageMask];
        
        self.style = aStyle;
    }
    
    return self;
}

- (void) setStyle:(FrameGridViewCellStyle)_frameStyle
{
    if (style != _frameStyle)
        style = _frameStyle;
    
    [self setStyleToNone];
    
    if (self.style == FrameGridViewCellStyleBasic)
        [self setStyleToBasic];
    else if (self.style == FrameGridViewCellStyleLarge)
        [self setStyleToLarge];
}

- (void) setStyleToNone
{
    [self.titleLabel removeFromSuperview];
    [self.rightLabel removeFromSuperview];
    [self.subtitleLabel removeFromSuperview];
}

/* Normal Style */
- (void) setStyleToBasic
{    
    /* Name Label */
    self.titleLabel                  = [[[UILabel alloc] initWithFrame:CGRectMake(7, 90, 100, 18)] autorelease];
    self.titleLabel.font              = [UIFont fontWithName:@"Myriad Pro" size:16];
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.backgroundColor   = [UIColor clearColor];
    [self addSubview: self.titleLabel];
    
    /* Age Label */
    self.rightLabel                   = [[[UILabel alloc] initWithFrame:CGRectMake(70, 89, 100, 15)] autorelease];
    self.rightLabel.font              = [UIFont fontWithName:@"Myriad" size:15];
    self.rightLabel.textColor = [UIColor grayColor];
    self.rightLabel.backgroundColor   = [UIColor clearColor];
    [self addSubview: self.rightLabel];
    
    /* Networks Label */
    self.subtitleLabel                   = [[[UILabel alloc] initWithFrame:CGRectMake(7, 102, 75, 15)] autorelease];
    self.subtitleLabel.font              = [UIFont fontWithName:@"Myriad" size:13];
    self.subtitleLabel.backgroundColor   = [UIColor clearColor];
    self.subtitleLabel.textColor = [UIColor grayColor];
    [self addSubview:self.subtitleLabel];
}

/* Smiles Received Style */
- (void) setStyleToLarge
{    
    /* Name Label */
    self.titleLabel                  = [[[UILabel alloc] initWithFrame:CGRectMake(7, 88, 100, 18)] autorelease];
    self.titleLabel.font              = [UIFont fontWithName:@"Myriad" size:14];
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.backgroundColor   = [UIColor clearColor];
    [self addSubview: self.titleLabel];
    
    /* Age Label */
    self.rightLabel                   = [[[UILabel alloc] initWithFrame:CGRectMake(70, 89, 100, 35)] autorelease];
    self.rightLabel.font              = [UIFont fontWithName:@"Myriad Pro" size:24];
    self.rightLabel.textColor = [UIColor redColor];
    self.rightLabel.backgroundColor   = [UIColor clearColor];
    [self addSubview: self.rightLabel];
    
    /* Networks Label */
    self.subtitleLabel                   = [[[UILabel alloc] initWithFrame:CGRectMake(7, 101, 75, 15)] autorelease];
    self.subtitleLabel.font              = [UIFont fontWithName:@"Myriad" size:14];
    self.subtitleLabel.backgroundColor   = [UIColor clearColor];
    self.subtitleLabel.textColor = [UIColor darkGrayColor];
    [self addSubview: self.subtitleLabel];
}

@end
