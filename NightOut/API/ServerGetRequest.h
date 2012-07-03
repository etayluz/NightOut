//
//  ServerRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/3/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"

@interface ServerGetRequest : NSObject <ASIHTTPRequestDelegate>

- (void) sendToUrl:(NSString *)url;
- (void) didFetchJson:(NSDictionary *)json;

@property (nonatomic, retain) ASIHTTPRequest *request;
@property (readonly) NSString *accessToken;

@end
