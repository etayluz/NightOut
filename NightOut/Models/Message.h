#import <Foundation/Foundation.h>

#import "AsDictionary.h"

@interface Message : NSObject <AsDictionary>

@property (nonatomic) NSInteger OID;
@property (nonatomic) NSInteger conversationID;
@property (nonatomic) NSInteger senderID;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSDate *time;
@property (nonatomic, retain) NSString *status;

@end
