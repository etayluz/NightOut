//
//  ScaledImageView.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/4/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ScaledImageView.h"
#import "UIImageView+WebCache.h"

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
        UIImage *croppedImage = [self scaleAndCrop:image toSize:self.frame.size];
        [self setImage:croppedImage];
    }
    failure:^(NSError *error) {
        NSLog(@"image load failure for %@", url);
    }];
}

- (UIImage *) scaleAndCrop:(UIImage *)image toSize:(CGSize)newSize;
{
    float ratio = image.size.width / image.size.height;
    
    UIGraphicsBeginImageContext(newSize);
    
    if (ratio > 1) { //width > height
        CGFloat newWidth = ratio * newSize.width;
        CGFloat newHeight = newSize.height;
        CGFloat leftMargin = (newWidth - newHeight) / 2;
        [image drawInRect:CGRectMake(-leftMargin, 0, newWidth, newHeight)];
    }
    else { // height > width
        //CGFloat newWidth = newSize.width;
        //CGFloat newHeight = newSize.height / ratio;
        //CGFloat topMargin = (newHeight - newWidth) / 2;
        CGFloat topMargin = 0;
        [image drawInRect:CGRectMake(0, -topMargin, newSize.width, newSize.height/ratio)];
    }
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
