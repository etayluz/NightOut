//
//  ServerRequest.h
//  NightOut
//
//  Created by Dan Berenholtz on 7/17/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"

#define SERVER_API_BASE_URL @"http://wwoapp.herokuapp.com/api/v1/"

//#define SERVER_API_BASE_URL @"http://localhost:3000/api/v1"

@interface ServerRequest : NSObject

@property (readonly) NSString *accessToken;
@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic, retain) MBProgressHUD *loadingIndicator;

@property (nonatomic) BOOL showProgress;
@property (nonatomic, retain) NSString *progressMessage;

- (void) didFetchJson:(NSDictionary *)json;
- (NSString *) fullUrl:(NSString *)url, ...;

- (void) showLoadingIndicatorForView:(UIView *)view;
- (void) showLoadingIndicator:(NSString *)message forView:(UIView *)view;

- (void) requestFinished:(ASIHTTPRequest *)request;
- (void) requestFailed:(ASIHTTPRequest *)request;

@end
