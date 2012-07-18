//
//  ConversationsViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 7/9/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "ConversationsViewController.h"
#import "ChatViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+ScaledImage.h"

@interface ConversationsViewController ()
@end

@implementation ConversationsViewController

@synthesize conversations;
@synthesize fetchAllConversationsRequest;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.fetchAllConversationsRequest = [[[FetchAllConversationsRequest alloc] init] autorelease];
    self.fetchAllConversationsRequest.delegate = self;
    
    [self.fetchAllConversationsRequest showLoadingIndicatorForView:self.navigationController.view];
    [self.fetchAllConversationsRequest send];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Conversation *conversation = [self.conversations objectAtIndex:indexPath.row];
    
    cell.textLabel.text = conversation.otherUser.name;
    cell.detailTextLabel.text = conversation.latestMessage.body;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    //[cell.imageView setImage:[UIImage imageNamed:@"WoodBackground.png"]];
    //[cell.imageView setImageWithURL:[NSURL URLWithString:conversation.otherUser.thumb]];
    cell.imageView.frame = CGRectMake(0, 0, cell.frame.size.height, cell.frame.size.height);
    cell.imageView.backgroundColor = [UIColor yellowColor];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.imageView setImageWithURLScaled:conversation.otherUser.thumb];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath");

    Conversation *conversation = [self.conversations objectAtIndex:indexPath.row];
    ChatViewController *chatVC = [[[ChatViewController alloc] init] autorelease];    
    
    chatVC.title = conversation.otherUser.name;
    [self.navigationController pushViewController:chatVC animated:YES];
    [chatVC updateFromConversationID:conversation.OID];
}

- (void)didFetchAllConversations:(NSArray *)_conversations
{
    self.conversations = _conversations;
    [self.tableView reloadData];
    NSLog(@"fetched convos");
}

@end
