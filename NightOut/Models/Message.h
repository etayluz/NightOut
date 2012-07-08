#import <Foundation/Foundation.h>

#import "AsDictionary.h"

@interface Message : NSObject <AsDictionary>

@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSDate *time;
@property (nonatomic, retain) NSString *status;

@property (nonatomic) NSInteger senderID;
@property (nonatomic) NSInteger receiverID;

@end
