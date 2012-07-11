//
//  UIImageView+ScaledImage.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/10/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "UIImageView+ScaledImage.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageTransformations.h"

@implementation UIImageView (ScaledImage)

- (void)setImageWithURLScaled:(NSString *)url
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
