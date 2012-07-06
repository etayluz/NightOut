//
//  PhotoSliderViewController.m
//  NightOut
//
//  Created by Dan Berenholtz on 6/24/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import "PhotoSliderViewController.h"
#import "UIImageView+WebCache.h"

@interface PhotoSliderViewController ()

@end

@implementation PhotoSliderViewController

@synthesize scrollView, tapRecognizer, pageLabel, urls;
@synthesize currentPage = _currentPage, totalPageCount;

- (NSInteger)totalPageCount
{
    return self.urls.count;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //[[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)] autorelease];

    _currentPage = 1;
    
    self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)] autorelease];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320, 1000);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.pageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)] autorelease];
    self.pageLabel.textAlignment = UITextAlignmentCenter;
    
    self.pageLabel.backgroundColor = [UIColor clearColor];
    self.pageLabel.textColor = [UIColor whiteColor];
    self.pageLabel.font = [UIFont boldSystemFontOfSize:14];
    self.pageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    [self.view addSubview:self.pageLabel];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    static NSInteger previousPage = 0;
    CGFloat pageWidth = _scrollView.frame.size.width;
    float fractionalPage = _scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        // Page has changed
        // Do your thing!
        previousPage = page;
        
        // Turn 0 based index to human index (starting at 1)
        _currentPage = page + 1;
        [self scrollViewDidChangePage:self.currentPage];
    }
}

- (void)scrollViewDidChangePage:(NSInteger) page
{
    [self updatePageLabel];
}

- (void)updatePageLabel
{
    self.pageLabel.text = [NSString stringWithFormat:@"%d of %d", self.currentPage, self.totalPageCount];
}

- (void)loadPhotoUrls:(NSArray *)imageUrls
{
    self.urls = imageUrls;
    
    for (int i = 0; i < self.urls.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *profileImageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        NSString *pictureUrl = [self.urls objectAtIndex:i];
        
        profileImageView.contentMode = UIViewContentModeScaleAspectFit;
        [profileImageView setImageWithURL:[NSURL URLWithString:pictureUrl]];
                
        [self.scrollView addSubview:profileImageView];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * imageUrls.count, self.scrollView.frame.size.height);
    
    [self updatePageLabel];
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

@end
