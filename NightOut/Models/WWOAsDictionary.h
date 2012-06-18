//
//  WWOAsDictionary.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/17/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WWOAsDictionary <NSObject>
- (id) initWithDictionary: (NSDictionary *) dictionary;
- (NSMutableDictionary *) toDictionary;
@end
