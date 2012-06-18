//
//  WWONearbyGridViewCell.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "WWONearbyGridViewCell.h"
#import "UIImageView+WebCache.h"

#import "WWOUser.h"

@implementation WWONearbyGridViewCell
@synthesize imageView, nameLabel, ageLabel;

- (void) dealloc
{
    [imageView release];
    [nameLabel release];
    [ageLabel release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(7, 4, 80, 80)] autorelease];
        self.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(7, 86, 100, 21)] autorelease];
        self.ageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(7, 108, 31, 21)] autorelease];        
        
        [self.contentView addSubview:imageView];
        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:ageLabel];
    }
    return self;
}

- (void) updateFromUser:(WWOUser *) user
{
    self.nameLabel.text = user.name;
    self.ageLabel.text = [user.age stringValue];
    [self.imageView setImageWithURL:[NSURL URLWithString:user.thumb]];
}

- (CALayer *) glowSelectionLayer
{
    return self.layer;
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
