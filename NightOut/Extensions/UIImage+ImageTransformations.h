//
//  UIImage+ImageTransformations.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/5/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageTransformations)

- (UIImage *) scaleAndCropToSize:(CGSize)newSize;

@end
