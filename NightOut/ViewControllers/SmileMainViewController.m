//
//  WWOSmileMainViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/20/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "SmileMainViewController.h"
#import "SmilesSentViewController.h"
#import "SmilesReceivedViewController.h"

@interface SmileMainViewController ()

@end

@implementation SmileMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *background = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"SmilesMain.png"]] autorelease];
    self.view.backgroundColor = background;

}

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
    SmilesSentViewController *smilesSentVC = [[[SmilesSentViewController alloc] init] autorelease];
    smilesSentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:smilesSentVC animated:YES];
}

- (void) showSmilesReceived
{
    SmilesReceivedViewController *smilesReceivedVC =[[[SmilesReceivedViewController alloc] init] autorelease];
    smilesReceivedVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:smilesReceivedVC animated:YES];
}

- (void) showSmilesMatches
{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
