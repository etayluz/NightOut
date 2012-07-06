// Old
#import "ChatViewController.h"
#import "Message.h"
#import "NSString+Additions.h"

// Exact same color as native iPhone Messages app.
// Achieved by taking a screen shot of the iPhone by pressing Home & Sleep buttons together.
// Then, emailed the image to myself and used Mac's native DigitalColor Meter app.
// Same => [UIColor colorWithRed:219.0/255.0 green:226.0/255.0 blue:237.0/255.0 alpha:1.0];
#define CHAT_BACKGROUND_COLOR [UIColor colorWithRed:0.859f green:0.886f blue:0.929f alpha:1.0f]

// 15 mins between messages before we show the date
#define SECONDS_BETWEEN_MESSAGES        (60*15)

static CGFloat const kSentDateFontSize = 13.0f;
static CGFloat const kMessageFontSize   = 16.0f;   // 15.0f, 14.0f
static CGFloat const kMessageTextWidth  = 180.0f;
static CGFloat const kContentHeightMax  = 84.0f;  // 80.0f, 76.0f
static CGFloat const kChatBarHeight1    = 40.0f;
static CGFloat const kChatBarHeight4    = 94.0f;

@implementation ChatViewController

@synthesize chatContent;

@synthesize chatBar;
@synthesize chatInput;
@synthesize previousContentHeight;
@synthesize sendButton;

@synthesize messages;

#pragma mark NSObject

- (void)dealloc {    
    self.chatContent = nil;
    self.chatBar = nil;
    self.chatInput = nil;
    self.sendButton = nil;
    
    [super dealloc];
}

#pragma mark UIViewController

- (void)viewDidUnload {
    self.chatContent = nil;
    self.chatBar = nil;
    self.chatInput = nil;
    self.sendButton = nil;
        
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messages = [NSMutableArray array];
    
    Message *message = [[[Message alloc] init] autorelease];
    message.text = @"woo";
    message.sentDate = [NSDate date];
    
    [self.messages addObject:message];
    
    
    NSLog(@"viewDidLoad");

    self.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    // Listen for keyboard.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    self.view.backgroundColor = CHAT_BACKGROUND_COLOR; // shown during rotation    
    
    [self createChatContent];
    [self createChatBar];
}

- (void) createChatContent
{
    chatContent = [[UITableView alloc] initWithFrame:
                   CGRectMake(0.0f, 0.0f, self.view.frame.size.width,
                              self.view.frame.size.height-kChatBarHeight1)];
    chatContent.clearsContextBeforeDrawing = NO;
    chatContent.delegate = self;
    chatContent.dataSource = self;
    chatContent.contentInset = UIEdgeInsetsMake(7.0f, 0.0f, 0.0f, 0.0f);
    chatContent.backgroundColor = CHAT_BACKGROUND_COLOR;
    chatContent.separatorStyle = UITableViewCellSeparatorStyleNone;
    chatContent.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:chatContent];
}

- (void) createChatBar
{
    chatBar = [[UIImageView alloc] initWithFrame:
               CGRectMake(0.0f, self.view.frame.size.height-kChatBarHeight1,
                          self.view.frame.size.width, kChatBarHeight1)];
    chatBar.clearsContextBeforeDrawing = NO;
    chatBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleWidth;
    chatBar.image = [[UIImage imageNamed:@"ChatBar.png"]
                     stretchableImageWithLeftCapWidth:18 topCapHeight:20];
    chatBar.userInteractionEnabled = YES;
    
    // Create chatInput.
    chatInput = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 9.0f, 234.0f, 22.0f)];
    chatInput.contentSize = CGSizeMake(234.0f, 22.0f);
    chatInput.delegate = self;
    chatInput.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    chatInput.scrollEnabled = NO; // not initially
    chatInput.scrollIndicatorInsets = UIEdgeInsetsMake(5.0f, 0.0f, 4.0f, -2.0f);
    chatInput.clearsContextBeforeDrawing = NO;
    chatInput.font = [UIFont systemFontOfSize:kMessageFontSize];
    chatInput.dataDetectorTypes = UIDataDetectorTypeAll;
    chatInput.backgroundColor = [UIColor clearColor];
    previousContentHeight = chatInput.contentSize.height;
    [chatBar addSubview:chatInput];
    
    // Create sendButton.
    sendButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    sendButton.clearsContextBeforeDrawing = NO;
    sendButton.frame = CGRectMake(chatBar.frame.size.width - 70.0f, 8.0f, 64.0f, 26.0f);
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | // multi-line input
    UIViewAutoresizingFlexibleLeftMargin;                       // landscape
    UIImage *sendButtonBackground = [UIImage imageNamed:@"SendButton.png"];
    [sendButton setBackgroundImage:sendButtonBackground forState:UIControlStateNormal];
    [sendButton setBackgroundImage:sendButtonBackground forState:UIControlStateDisabled];
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    sendButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    UIColor *shadowColor = [[UIColor alloc] initWithRed:0.325f green:0.463f blue:0.675f alpha:1.0f];
    [sendButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    [shadowColor release];
    [sendButton addTarget:self action:@selector(sendMessage)
         forControlEvents:UIControlEventTouchUpInside];

    [self resetSendButton]; // disable initially
    
    [self.chatBar addSubview:sendButton];
    [self.view addSubview:chatBar];
    [self.view sendSubviewToBack:chatBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated]; // below: work around for [chatContent flashScrollIndicators]
    NSLog(@"viewWillAppear");
    [self.chatContent performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0.0];
    [self scrollToBottomAnimated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.chatInput resignFirstResponder];
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) setChatBarHeight:(CGFloat)height
{
    CGRect chatContentFrame = self.chatContent.frame;
    chatContentFrame.size.height = self.view.frame.size.width - height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1f];
    self.chatContent.frame = CGRectMake(chatBar.frame.origin.x, chatContentFrame.size.height, self.view.frame.size.width, height);
    [UIView commitAnimations];
}

- (void) resetChatBarHeight
{
    [self setChatBarHeight:kChatBarHeight1];
}

- (void) expandChatBarHeight
{
    [self setChatBarHeight:kChatBarHeight4];
}

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat contentHeight = textView.contentSize.height - kMessageFontSize + 2.0f;
    NSString *rightTrimmedText = @"";
        
    if ([textView hasText]) {
        rightTrimmedText = [textView.text
                            stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
        
        if (textView.text.length > 1024) { // truncate text to 1024 chars
            textView.text = [textView.text substringToIndex:1024];
        }
        
        // Resize textView to contentHeight
        if (contentHeight != previousContentHeight) {
            if (contentHeight <= kContentHeightMax) { // limit chatInputHeight <= 4 lines
                CGFloat chatBarHeight = contentHeight + 18.0f;
                [self setChatBarHeight:chatBarHeight];
                if (previousContentHeight > kContentHeightMax) {
                    textView.scrollEnabled = NO;
                }
                textView.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk
                [self scrollToBottomAnimated:YES];
           } else if (previousContentHeight <= kContentHeightMax) { // grow
                textView.scrollEnabled = YES;
                textView.contentOffset = CGPointMake(0.0f, contentHeight-68.0f); // shift to bottom
                if (previousContentHeight < kContentHeightMax) {
                    [self expandChatBarHeight];
                    [self scrollToBottomAnimated:YES];
                }
            }
        }
    } else { // textView is empty
        if (previousContentHeight > 22.0f) {
            [self resetChatBarHeight];
            if (previousContentHeight > kContentHeightMax) {
                textView.scrollEnabled = NO;
            }
        }
        textView.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk
    }

    // Enable sendButton if chatInput has non-blank text, disable otherwise.
    if (rightTrimmedText.length > 0) {
        [self enableSendButton];
    } else {
        [self disableSendButton];
    }
    
    previousContentHeight = contentHeight;
}

// Fix a scrolling quirk.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    textView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 3.0f, 0.0f);
    return YES;
}

#pragma mark ChatViewController

- (void)enableSendButton {
    if (sendButton.enabled == NO) {
        sendButton.enabled = YES;
        sendButton.titleLabel.alpha = 1.0f;
    }
}

- (void)disableSendButton {
    if (sendButton.enabled == YES) {
        [self resetSendButton];
    }
}

- (void)resetSendButton {
    sendButton.enabled = NO;
    sendButton.titleLabel.alpha = 0.5f; // Sam S. says 0.4f
}


# pragma mark Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    [self resizeViewWithOptions:[notification userInfo]];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self resizeViewWithOptions:[notification userInfo]];
}

- (void)resizeViewWithOptions:(NSDictionary *)options {    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    [[options objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[options objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[options objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    CGRect viewFrame = self.view.frame;
    NSLog(@"viewFrame y: %@", NSStringFromCGRect(viewFrame));

    CGRect keyboardFrameEndRelative = [self.view convertRect:keyboardEndFrame fromView:nil];
    NSLog(@"self.view: %@", self.view);
    NSLog(@"keyboardFrameEndRelative: %@", NSStringFromCGRect(keyboardFrameEndRelative));

    viewFrame.size.height =  keyboardFrameEndRelative.origin.y;
    self.view.frame = viewFrame;
    [UIView commitAnimations];
    
    [self scrollToBottomAnimated:YES];
    
    chatInput.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 3.0f, 0.0f);
    chatInput.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger bottomRow = self.messages.count - 1;
    if (bottomRow >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:bottomRow inSection:0];
        [chatContent scrollToRowAtIndexPath:indexPath
                           atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

#pragma mark Message

- (void)sendMessage {
//    // TODO: Show progress indicator like iPhone Message app does. (Icebox)
//    [activityIndicator startAnimating];
    
    NSString *rightTrimmedMessage =
        [chatInput.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
    
    // Don't send blank messages.
    if (rightTrimmedMessage.length == 0) {
        [self clearChatInput];
        return;
    }
    
    // Create new message and save to Core Data.
    Message *newMessage = [[[Message alloc] init] autorelease];
    newMessage.text = rightTrimmedMessage;
    newMessage.sentDate = [NSDate date];
    
    [self.messages addObject:newMessage];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:(self.messages.count - 1) inSection:0];
    [self.chatContent insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];

    
    [self clearChatInput];
    [self scrollToBottomAnimated:YES]; // must come after RESET_CHAT_BAR_HEIGHT above
}

- (void)clearChatInput {
    chatInput.text = @"";
    if (previousContentHeight > 22.0f) {
        [self resetChatBarHeight];
        chatInput.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 3.0f, 0.0f);
        chatInput.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk
        [self scrollToBottomAnimated:YES];       
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"number of rows: %d", [cellMap count]);
    return self.messages.count;
}

#define SENT_DATE_TAG 101
#define TEXT_TAG 102
#define BACKGROUND_TAG 103

static NSString *kMessageCell = @"MessageCell";

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *msgSentDate;
    UIImageView *msgBackground;
    UILabel *msgText;
        
    NSObject *object = [self.messages objectAtIndex:indexPath.row];
    
    UITableViewCell *cell;
    
    // Handle sentDate (NSDate).
    if ([object isKindOfClass:[NSDate class]]) {
        static NSString *kSentDateCellId = @"SentDateCell";
        cell = [tableView dequeueReusableCellWithIdentifier:kSentDateCellId];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:kSentDateCellId] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // Create message sentDate lable
            msgSentDate = [[UILabel alloc] initWithFrame:
                            CGRectMake(-2.0f, 0.0f,
                                       tableView.frame.size.width, kSentDateFontSize+5.0f)];
            msgSentDate.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            msgSentDate.clearsContextBeforeDrawing = NO;
            msgSentDate.tag = SENT_DATE_TAG;
            msgSentDate.font = [UIFont boldSystemFontOfSize:kSentDateFontSize];
            msgSentDate.lineBreakMode = UILineBreakModeTailTruncation;
            msgSentDate.textAlignment = UITextAlignmentCenter;
            msgSentDate.backgroundColor = CHAT_BACKGROUND_COLOR; // clearColor slows performance
            msgSentDate.textColor = [UIColor grayColor];
            [cell addSubview:msgSentDate];
            [msgSentDate release];
        } else {
            msgSentDate = (UILabel *)[cell viewWithTag:SENT_DATE_TAG];
        }
        
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle]; // Jan 1, 2010
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];  // 1:43 PM
            
            // TODO: Get locale from iPhone system prefs. Then, move this to viewDidAppear.
            NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [dateFormatter setLocale:usLocale];
            [usLocale release];
        }
        
        msgSentDate.text = [dateFormatter stringFromDate:(NSDate *)object];
        
        return cell;
    }
    
    // Handle Message object.
    cell = [tableView dequeueReusableCellWithIdentifier:kMessageCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kMessageCell] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // Create message background image view
        msgBackground = [[UIImageView alloc] init];
        msgBackground.clearsContextBeforeDrawing = NO;
        msgBackground.tag = BACKGROUND_TAG;
        msgBackground.backgroundColor = CHAT_BACKGROUND_COLOR; // clearColor slows performance
        [cell.contentView addSubview:msgBackground];
        [msgBackground release];
        
        // Create message text label
        msgText = [[UILabel alloc] init];
        msgText.clearsContextBeforeDrawing = NO;
        msgText.tag = TEXT_TAG;
        msgText.backgroundColor = [UIColor clearColor];
        msgText.numberOfLines = 0;
        msgText.lineBreakMode = UILineBreakModeWordWrap;
        msgText.font = [UIFont systemFontOfSize:kMessageFontSize];
        [cell.contentView addSubview:msgText];
        [msgText release];
    } else {
        msgBackground = (UIImageView *)[cell.contentView viewWithTag:BACKGROUND_TAG];
        msgText = (UILabel *)[cell.contentView viewWithTag:TEXT_TAG];
    }
    
    // Configure the cell to show the message in a bubble. Layout message cell & its subviews.
    CGSize size = [[(Message *)object text] sizeWithFont:[UIFont systemFontOfSize:kMessageFontSize]
                                       constrainedToSize:CGSizeMake(kMessageTextWidth, CGFLOAT_MAX)
                                           lineBreakMode:UILineBreakModeWordWrap];
    UIImage *bubbleImage;
    if (!([indexPath row] % 3)) { // right bubble
        CGFloat editWidth = tableView.editing ? 32.0f : 0.0f;
        msgBackground.frame = CGRectMake(tableView.frame.size.width-size.width-34.0f-editWidth,
                                         kMessageFontSize-13.0f, size.width+34.0f,
                                         size.height+12.0f);
        bubbleImage = [[UIImage imageNamed:@"ChatBubbleGreen.png"]
                       stretchableImageWithLeftCapWidth:15 topCapHeight:13];
        msgText.frame = CGRectMake(tableView.frame.size.width-size.width-22.0f-editWidth,
                                   kMessageFontSize-9.0f, size.width+5.0f, size.height);
        msgBackground.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        msgText.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    } else { // left bubble
        msgBackground.frame = CGRectMake(0.0f, kMessageFontSize-13.0f,
                                         size.width+34.0f, size.height+12.0f);
        bubbleImage = [[UIImage imageNamed:@"ChatBubbleGray.png"]
                       stretchableImageWithLeftCapWidth:23 topCapHeight:15];
        msgText.frame = CGRectMake(22.0f, kMessageFontSize-9.0f, size.width+5.0f, size.height);
        msgBackground.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        msgText.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    }
    msgBackground.image = bubbleImage;
    msgText.text = [(Message *)object text];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *object = [self.messages objectAtIndex:indexPath.row];
    
    // Set SentDateCell height.
    if ([object isKindOfClass:[NSDate class]]) {
        return kSentDateFontSize + 7.0f;
    }
    
    // Set MessageCell height.
    CGSize size = [[(Message *)object text] sizeWithFont:[UIFont systemFontOfSize:kMessageFontSize]
                                       constrainedToSize:CGSizeMake(kMessageTextWidth, CGFLOAT_MAX)
                                           lineBreakMode:UILineBreakModeWordWrap];
    return size.height + 17.0f;
}

@end
