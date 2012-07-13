//
//  UILabel+Extensions.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/13/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "UILabel+Extensions.h"

@implementation UILabel (Extensions)

- (void)setNonRepeatingBackgroundImage:(UIImageView *)aNonRepeatingBackgroundImage {
    [self addSubview:aNonRepeatingBackgroundImage];
    [self sendSubviewToBack:aNonRepeatingBackgroundImage];
    [self setBackgroundColor:[UIColor clearColor]];
}

@end
