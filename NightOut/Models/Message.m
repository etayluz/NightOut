#import "Message.h"

@implementation Message
@synthesize body, time, status;
@synthesize senderID, receiverID;

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
        self.body = [dictionary objectForKey:@"body"];
        self.time = [NSDate date];
        self.status = @"received";
        
        self.senderID = [[dictionary objectForKey:@"sender_id"] integerValue];
        self.receiverID = [[dictionary objectForKey:@"receiver_id"] integerValue];
    }
    return self;
}

- (NSMutableDictionary *) toDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:self.body forKey:@"body"];
    [dictionary setObject:self.time forKey:@"time"];
    [dictionary setObject:self.status forKey:@"status"];
    
    return dictionary;
}

@end
