//
//  ScaledImageView.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/4/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ScaledImageView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageTransformations.h"

@implementation ScaledImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setUrl:(NSString *)url
{
    [self setImageWithURL:[NSURL URLWithString:url] 
    success:^(UIImage *image) {
        UIImage *croppedImage = [image scaleAndCropToSize:self.frame.size];
        [self setImage:croppedImage];
    }
    failure:^(NSError *error) {
        NSLog(@"image load failure for %@", url);
    }];
}

@end
