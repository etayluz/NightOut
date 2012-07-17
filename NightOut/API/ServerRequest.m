//
//  ServerRequest.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/17/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ServerRequest.h"
#import "ServerInterface.h"

@implementation ServerRequest

@synthesize accessToken;

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

- (void) didFetchJson:(NSDictionary *)json
{
    // to be overridden
}

@end
