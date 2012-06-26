//
//  WWOMessagesViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/16/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "Notification.h"

#import "ConversationsViewController.h"
#import "WWOMessagesViewController.h"

#import "ServerInterface.h"
#import "Conversation.h"

@interface ConversationsViewController ()
@property (retain) NSArray *conversations;
@end

@implementation ConversationsViewController

@synthesize conversations;

- (void) dealloc
{
    [Notification unregisterNotification:@"DidFetchMessages" target:self];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Notification registerNotification:@"DidFetchMessages" target:self selector:@selector(loadedMessages:)];
    [[ServerInterface sharedManager] fetchMessages];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WWOConversationCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    Conversation *conversation = [conversations objectAtIndex:indexPath.row];
    cell.textLabel.text = conversation.name;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.row;
    Conversation *conversation = [self.conversations objectAtIndex:index];
    NSLog(@"clicked index = %d", index);
    
    WWOMessagesViewController *messagesViewController = [[[WWOMessagesViewController alloc] init] autorelease];
    
    [self.navigationController pushViewController:messagesViewController animated:YES];
    messagesViewController.nameLabel.text = conversation.name;
}

#pragma mark - Notifications
- (void)loadedMessages:(NSNotification *) notification
{
    self.conversations = [notification.userInfo objectForKey:@"data"];
    NSLog(@"%d", self.conversations.count);
    [self.tableView reloadData];
}

@end
