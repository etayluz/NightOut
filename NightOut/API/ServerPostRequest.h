//
//  ServerPostRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/3/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"

@interface ServerPostRequest : ServerRequest

- (void) sendToUrl:(NSString *)url;
- (void) sendToUrl:(NSString *)url withParams:(NSDictionary *)params;

@property (nonatomic, retain) ASIFormDataRequest *request;

@end
