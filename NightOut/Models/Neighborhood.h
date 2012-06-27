//
//  Neighborhood.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/27/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsDictionary.h"

@interface Neighborhood : NSObject <AsDictionary>

@property (nonatomic, retain) NSMutableArray *users;
@property (nonatomic, retain) NSString *name;

@end
