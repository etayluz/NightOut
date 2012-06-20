//
//  WWOLoginViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/19/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "WWOLoginViewController.h"
#import "Notification.h"
#import "WWOServerInterface.h"

@interface WWOLoginViewController ()

@end

@implementation WWOLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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


- (IBAction)userDidClickLogin:(id)sender
{
    //[Notification send:@"UserDidLogin"];
    [[WWOServerInterface sharedManager] showLoginPrompt];
}

@end
