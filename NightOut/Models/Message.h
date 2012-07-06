@interface Message : NSObject {

}

@property (nonatomic, retain) NSDate *sentDate;
@property (nonatomic, retain) NSNumber *read;
@property (nonatomic, retain) NSString *text;

@end
