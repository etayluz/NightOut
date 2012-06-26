//
//  WWOSmilesSentViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/20/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "SmilesSentViewController.h"
#import "SmilesView.h"

@interface SmilesSentViewController ()

@end

@implementation SmilesSentViewController
@synthesize scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)] autorelease];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320, 640);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    UILabel *youSmiledAtLabel         = [[[UILabel alloc] initWithFrame:CGRectMake(85, 20, 200, 15)] autorelease];
    youSmiledAtLabel.font             = [UIFont boldSystemFontOfSize:20];
    youSmiledAtLabel.backgroundColor  = [UIColor whiteColor];
    youSmiledAtLabel.text             = @"You Smiled At";
    [self.scrollView addSubview:youSmiledAtLabel];

    for (int i = 0; i < 9; i++)
    {
        SmilesGridViewCell *smilesView = [[[SmilesGridViewCell alloc] initWithFrame:CGRectMake(20, 50, 100, 130)] autorelease];
        [self.scrollView addSubview:smilesView];
    }
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
