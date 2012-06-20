//
//  WWOSmileMainViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/20/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "WWOSmileMainViewController.h"
#import "WWOSmilesSentViewController.h"
#import "WWOSmilesReceivedViewController.h"
#import "WWOSmileMatchesViewController.h"

@interface WWOSmileMainViewController ()

@end

@implementation WWOSmileMainViewController

- (IBAction)didClickSmilesSentButton:(id)sender
{
    NSLog(@"did click smiles sent button");
    [self showSmilesSent];
}

- (IBAction)didClickSmilesReceivedButton:(id)sender
{
    NSLog(@"did click received button");
    [self showSmilesReceived];
}

- (IBAction)didClickSmileMatchesButton:(id)sender
{
    NSLog(@"did click smile matches button");
    [self showSmilesMatches];
}

- (void) showSmilesSent
{
    WWOSmilesSentViewController *smilesSentVC = [[[WWOSmilesSentViewController alloc] init] autorelease];
    [self.navigationController pushViewController:smilesSentVC animated:YES];
}

- (void) showSmilesReceived
{
    WWOSmilesReceivedViewController *smilesReceivedVC =[[[WWOSmilesReceivedViewController alloc] init] autorelease];
    [self.navigationController pushViewController:smilesReceivedVC animated:YES];
}

- (void) showSmilesMatches
{
    WWOSmileMatchesViewController *smileMatchesVC = [[[WWOSmileMatchesViewController alloc] init] autorelease];
    [self.navigationController pushViewController:smileMatchesVC animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

@end
