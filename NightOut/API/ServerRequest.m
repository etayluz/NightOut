//
//  ServerRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/17/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerRequest.h"
#import "ServerInterface.h"
#import "JSONKit.h"
#import "ASIHTTPRequest.h"

@implementation ServerRequest

@synthesize accessToken, request, loadingIndicator, showProgress, progressMessage;

- (NSString *) fullUrl:(NSString *)url, ...
{
    va_list args;
    va_start(args, url);
    NSString *formattedUrl =[[[NSString alloc] initWithFormat:url arguments:args] autorelease];
    va_end(args);
        
    return [NSString stringWithFormat:@"%@/%@?token=%@", SERVER_API_BASE_URL, formattedUrl, self.accessToken];
}

- (NSString *) accessToken
{
    return [ServerInterface sharedManager].facebook.accessToken;
}

- (void) requestFinished:(ASIHTTPRequest *)_request
{
    NSString *jsonString = _request.responseString;
    NSDictionary *responseDict = [jsonString objectFromJSONString];
    [self didFetchJson:responseDict];
    
    [self hideLoadingBadge];
}

- (void) requestFailed:(ASIHTTPRequest *)_request
{
    [self hideLoadingBadge];
}

- (void) didFetchJson:(NSDictionary *)json
{
    // to be overridden
}

- (void) showLoadingIndicatorForView:(UIView *)view
{
    [self showLoadingIndicator:nil forView:view];
}

- (void) showLoadingIndicator:(NSString *)message forView:(UIView *)view
{
    self.loadingIndicator = [[[MBProgressHUD alloc] initWithView:view] autorelease];
    self.loadingIndicator.removeFromSuperViewOnHide = YES;
	self.loadingIndicator.labelText = message;
    
    [view addSubview:self.loadingIndicator];
    [self.loadingIndicator show:YES];
}

- (void) hideLoadingBadge
{
    [self.loadingIndicator hide:YES];
}

@end
