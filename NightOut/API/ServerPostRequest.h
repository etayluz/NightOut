//
//  ServerPostRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/3/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"

@interface ServerPostRequest : NSObject

- (void) sendToUrl:(NSString *)url;
- (void) sendToUrl:(NSString *)url withParams:(NSDictionary *)params;
- (void) didFetchJson:(NSDictionary *)json;

@property (nonatomic, retain) ASIFormDataRequest *request;
@property (readonly) NSString *accessToken;

@end
