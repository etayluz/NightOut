//
//  SmileGameChoice.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AsDictionary.h"
#import "User.h"

@interface SmileGameChoice : NSObject <AsDictionary>

@property (nonatomic) NSInteger OID;
@property (nonatomic) NSInteger smileGameID;

@property (nonatomic, retain) NSString *status;
@property (nonatomic) NSInteger position;

@property (nonatomic, retain) User *user;

@end
