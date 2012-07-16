//
//  SmileGame.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/12/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "AsDictionary.h"
#import "SmileGame.h"
#import "SmileGameChoice.h"

@implementation SmileGame 

@synthesize OID;
@synthesize sender, receiver;
@synthesize guessesRemaining;
@synthesize choices;

- (id) initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [self init]) {
        self.OID = [[dictionary objectForKey:@"id"] integerValue];
        
        if ([dictionary objectForKey:@"sender"] != [NSNull null])
            self.sender = [[[User alloc] initWithDictionary:[dictionary objectForKey:@"sender"]] autorelease];
        
        if ([dictionary objectForKey:@"receiver"] != [NSNull null])
            self.receiver = [[[User alloc] initWithDictionary:[dictionary objectForKey:@"receiver"]] autorelease];
        
        self.guessesRemaining = [[dictionary objectForKey:@"guesses_remaining"] integerValue];
        
        self.choices = [NSMutableArray array];
        if ([dictionary objectForKey:@"choices"] != [NSNull null]) {
            NSArray *choiceDictionaries = [dictionary objectForKey:@"choices"];
            for (NSDictionary *curChoiceDict in choiceDictionaries) {
                SmileGameChoice *c = [[[SmileGameChoice alloc] initWithDictionary:curChoiceDict] autorelease];
                [self.choices addObject:c];
            }
        }
    }
    return self;
}

@end
