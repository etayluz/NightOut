//
//  UserFrameLabel.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/12/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "UserFrameOverlay.h"

@implementation UserFrameOverlay

@synthesize titleLabel, subtitleLabel, rightLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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

@end
