//
//  UIImage+ImageTransformations.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/5/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "UIImage+ImageTransformations.h"

@implementation UIImage (ImageTransformations)

- (UIImage *) scaleAndCropToSize:(CGSize)newSize;
{
    float ratio = self.size.width / self.size.height;
    
    UIGraphicsBeginImageContext(newSize);
    
    if (ratio > 1) { //width > height
        CGFloat newWidth = ratio * newSize.width;
        CGFloat newHeight = newSize.height;
        CGFloat leftMargin = (newWidth - newHeight) / 2;
        [self drawInRect:CGRectMake(-leftMargin, 0, newWidth, newHeight)];
    }
    else { // height > width
        //CGFloat newWidth = newSize.width;
        //CGFloat newHeight = newSize.height / ratio;
        //CGFloat topMargin = (newHeight - newWidth) / 2;
        CGFloat topMargin = 0;
        [self drawInRect:CGRectMake(0, -topMargin, newSize.width, newSize.height/ratio)];
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
