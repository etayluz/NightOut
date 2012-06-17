//
//  WWONearbyGridViewCell.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "WWONearbyGridViewCellContent.h"

@implementation WWONearbyGridViewCellContent

@synthesize imageView, nameLabel, ageLabel;

- (void) dealloc
{
    [imageView release];
    [nameLabel release];
    [ageLabel release];
    
    [super dealloc];
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
