// Old
#import <AudioToolbox/AudioToolbox.h>

@class Message;

@interface ChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {

}

@property (nonatomic, retain) UITableView *chatContent;

@property (nonatomic, retain) UIImageView *chatBar;

@property (nonatomic, retain) UITextView *chatInput;
@property (nonatomic, assign) CGFloat previousContentHeight;
@property (nonatomic, retain) UIButton *sendButton;

@property (nonatomic, retain) NSMutableArray *messages;

- (void)enableSendButton;
- (void)disableSendButton;
- (void)resetSendButton;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)resizeViewWithOptions:(NSDictionary *)options;
- (void)scrollToBottomAnimated:(BOOL)animated;

- (void)sendMessage;
- (void)clearChatInput;

@end
