//
//  ThumbViewCell.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/22/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ThumbViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@implementation ThumbViewCell

@synthesize imageView, nameLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        // Initialization code
        self.contentView.backgroundColor = [UIColor lightGrayColor];
 
        //self.contentView.layer.borderColor = [UIColor greenColor].CGColor;
        //self.contentView.layer.borderWidth = 1.0f;

        NSInteger margin = 10;
        NSInteger thumbnailWidth = frame.size.width - 2 * margin;
        NSInteger thumbnailHeight = thumbnailWidth;
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, thumbnailWidth, thumbnailHeight)] autorelease];

        self.nameLabel                     = [[[UILabel alloc] initWithFrame:CGRectMake(0, margin + thumbnailHeight, frame.size.width, 15)] autorelease];
        self.nameLabel.textAlignment = UITextAlignmentCenter;
        self.nameLabel.font                = [UIFont boldSystemFontOfSize:11];
        self.nameLabel.backgroundColor     = [UIColor clearColor];
                
        [self.contentView addSubview:imageView];
        [self.contentView addSubview:nameLabel];
    }
    return self;
}

- (void) dealloc
{
    [imageView release];
    [nameLabel release];
    
    [super dealloc];
}

@end
