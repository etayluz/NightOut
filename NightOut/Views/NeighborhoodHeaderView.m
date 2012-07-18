//
//  NeighborhoodHeaderView.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/18/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "NeighborhoodHeaderView.h"
#import "UIImageView+ScaledImage.h"

@implementation NeighborhoodHeaderView

@synthesize backgroundImageView, profilePicImageView;

- (void) dealloc
{
    self.backgroundImageView = nil;
    self.profilePicImageView = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.profilePicImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(120, 45, 90, 90)] autorelease];
        [self addSubview:self.profilePicImageView];
        
        self.backgroundImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NearbyHeader.png"]] autorelease];
        [self addSubview:self.backgroundImageView];
    }
    return self;
}

- (void) updateWithUser:(User *)user
{
    [self.profilePicImageView setImageWithURLScaled:user.thumb];
}

@end
