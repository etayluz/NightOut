// Old
#import <AudioToolbox/AudioToolbox.h>
#import "FetchConversationRequest.h"
#import "SendMessageRequest.h"
#import "Conversation.h"

@class Message;

@interface ChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, FetchConversationRequestDelegate> {

}

@property (nonatomic, retain) UITableView *chatContent;

@property (nonatomic, retain) UIImageView *chatBar;

@property (nonatomic, retain) UITextView *chatInput;
@property (nonatomic, assign) CGFloat previousContentHeight;
@property (nonatomic, retain) UIButton *sendButton;

@property (nonatomic, retain) Conversation *conversation;

@property (nonatomic, retain) FetchConversationRequest *fetchConversationRequest;
@property (nonatomic, retain) SendMessageRequest *sendMessageRequest;

- (void)enableSendButton;
- (void)disableSendButton;
- (void)resetSendButton;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)resizeViewWithOptions:(NSDictionary *)options;
- (void)scrollToBottomAnimated:(BOOL)animated;

- (void)sendMessage;
- (void)clearChatInput;

- (void)updateFromConversationID:(NSInteger)conversationID;

@end
