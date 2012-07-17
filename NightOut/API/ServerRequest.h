//
//  ServerRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/17/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define SERVER_API_BASE_URL @"http://wwoapp.herokuapp.com/api/v1/"
//#define SERVER_API_BASE_URL @"http://wwoapp.herokuapp.com/api/v1/"

#define SERVER_API_BASE_URL @"http://localhost:3000/api/v1"

@interface ServerRequest : NSObject

@property (readonly) NSString *accessToken;

- (void) didFetchJson:(NSDictionary *)json;
- (NSString *) fullUrl:(NSString *)url, ...;

@end
