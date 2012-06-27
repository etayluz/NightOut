//
//  SmilesView.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/25/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "SmilesGridViewCell.h"

@implementation SmilesGridViewCell
@synthesize imageView, nameLabel, ageLabel, networkLabel, imageMask;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame];
    if (self) {

        //self.backgroundColor = [UIColor orangeColor];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        /* Image View */
        UIImage *pic = [UIImage imageNamed:@"header.png"];
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)] autorelease];
        [self.imageView setImage:pic];
        [self.contentView addSubview: self.imageView];
        
        /* Image Mask */
        self.imageMask = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 100)] autorelease];
        [self.imageMask setImage:[UIImage imageNamed:@"ImageMask1.png"]];
        [self.contentView addSubview: self.imageMask];
        
        /* Name Label */
        self.nameLabel                  = [[[UILabel alloc] initWithFrame:CGRectMake(10, 70, 100, 15)] autorelease];
        self.nameLabel.font              = [UIFont boldSystemFontOfSize:10];
        self.nameLabel.backgroundColor   = [UIColor clearColor];
        self.nameLabel.text = @"Venkat";
        [self.contentView addSubview: self.nameLabel];

        /* Age Label */
        self.ageLabel                   = [[[UILabel alloc] initWithFrame:CGRectMake(55, 70, 100, 15)] autorelease];
        self.ageLabel.font              = [UIFont boldSystemFontOfSize:10];
        self.ageLabel.backgroundColor   = [UIColor clearColor];
        self.ageLabel.text = @"25";
        [self.contentView addSubview: self.ageLabel];

        /* Network Label */
        self.networkLabel                   = [[[UILabel alloc] initWithFrame:CGRectMake(10, 80, 100, 15)] autorelease];
        self.networkLabel.font              = [UIFont boldSystemFontOfSize:10];
        self.networkLabel.backgroundColor   = [UIColor clearColor];
        self.networkLabel.text = @"Stanford";
        [self.contentView addSubview: self.networkLabel];
    }

    return self;
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
