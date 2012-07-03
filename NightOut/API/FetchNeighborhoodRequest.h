//
//  FetchNeighborhoodRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/29/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Neighborhood.h"
#import "ServerRequest.h"

@protocol FetchNeighborhoodRequestDelegate <NSObject>
- (void) didFetchNeighborhood:(Neighborhood *)neighborhood;
@end

@interface FetchNeighborhoodRequest : ServerRequest
- (void) send;

@property (assign) id <FetchNeighborhoodRequestDelegate> delegate;

@end
