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
        self.contentView.backgroundColor = [UIColor colorWithRed:0.929 green:0.933 blue:0.863 alpha:1];
 
        //self.contentView.layer.borderColor = [UIColor greenColor].CGColor;
        //self.contentView.layer.borderWidth = 1.0f;

        NSInteger margin = 4;
        NSInteger thumbnailWidth = frame.size.width - 2 * margin;
        NSInteger thumbnailHeight = thumbnailWidth;
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(margin, -3, thumbnailWidth, thumbnailHeight)] autorelease];

        self.nameLabel                     = [[[UILabel alloc] initWithFrame:CGRectMake(margin, thumbnailHeight, frame.size.width - 2, 15)] autorelease];
        self.nameLabel.textAlignment = UITextAlignmentLeft;
//        self.nameLabel.font                = [UIFont boldSystemFontOfSize:10];
        self.nameLabel.font = [UIFont fontWithName:@"Myriad Pro" size:13];
        self.nameLabel.backgroundColor     = [UIColor clearColor];
        self.nameLabel.textColor           = [UIColor darkGrayColor];
                
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
