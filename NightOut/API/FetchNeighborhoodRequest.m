//
//  FetchNeighborhoodRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/29/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "FetchNeighborhoodRequest.h"
#import "ServerInterface.h"

@implementation FetchNeighborhoodRequest : ServerGetRequest
@synthesize delegate;

- (void) send
{
    if (!self.request) {
        NSString *url = [NSString stringWithFormat:@"http://wwoapp.herokuapp.com/api/v1/nearby?token=%@", self.accessToken];
        [self sendToUrl:url];
    }
}

- (void) didFetchJson:(NSDictionary *)json
{
    Neighborhood *neighborhood = [[[Neighborhood alloc] initWithDictionary:json] autorelease];
    [self.delegate didFetchNeighborhood:neighborhood];
}

@end
