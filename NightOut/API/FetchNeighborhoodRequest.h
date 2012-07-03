//
//  FetchNeighborhoodRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/29/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Neighborhood.h"
#import "ServerGetRequest.h"

@protocol FetchNeighborhoodRequestDelegate <NSObject>
- (void) didFetchNeighborhood:(Neighborhood *)neighborhood;
@end

@interface FetchNeighborhoodRequest : ServerGetRequest
- (void) send;

@property (assign) id <FetchNeighborhoodRequestDelegate> delegate;

@end
