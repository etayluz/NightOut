#import "Message.h"

@implementation Message
@synthesize OID;
@synthesize conversationID, senderID;
@synthesize body, time, status;

- (void) dealloc
{
    self.body = nil;
    self.time = nil;
    self.status = nil;
    
    [super dealloc];
}

- (id) initWithDictionary: (NSDictionary *) dictionary
{
    if (self = [self init]) {
        self.OID = [[dictionary objectForKey:@"id"] integerValue];
        self.conversationID = [[dictionary objectForKey:@"conversation_id"] integerValue];
        self.senderID = [[dictionary objectForKey:@"sender_id"] integerValue];
        
        self.body = [dictionary objectForKey:@"body"];
        self.time = [NSDate date];
        self.status = @"received";
        
    }
    return self;
}

- (NSMutableDictionary *) toDictionary
{
    return nil;
}

@end
