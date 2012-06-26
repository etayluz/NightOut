//
//  SmilesView.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/25/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "SmilesGridViewCell.h"

@implementation SmilesGridViewCell
@synthesize imageView, nameLabel, ageLabel, networkLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor orangeColor];
        /* Image Label */
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
        self.imageView.backgroundColor = [UIColor greenColor];
        [self addSubview: self.imageView];

        /* Name Label */
        self.nameLabel                  = [[[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 15)] autorelease];
        self.nameLabel.font              = [UIFont boldSystemFontOfSize:13];
        self.nameLabel.backgroundColor   = [UIColor clearColor];
        self.nameLabel.text = @"Venkat";
        [self addSubview: self.nameLabel];

        /* Age Label */
        self.ageLabel                   = [[[UILabel alloc] initWithFrame:CGRectMake(80, 100, 100, 15)] autorelease];
        self.ageLabel.font              = [UIFont boldSystemFontOfSize:13];
        self.ageLabel.backgroundColor   = [UIColor clearColor];
        self.ageLabel.text = @"25";
        [self addSubview: self.ageLabel];

        /* Network Label */
        self.networkLabel                   = [[[UILabel alloc] initWithFrame:CGRectMake(0, 113, 100, 15)] autorelease];
        self.networkLabel.font              = [UIFont boldSystemFontOfSize:13];
        self.networkLabel.backgroundColor   = [UIColor clearColor];
        self.networkLabel.text = @"Stanford";
        [self addSubview: self.networkLabel];
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
