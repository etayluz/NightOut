//
//  PhotoSliderViewController.h
//  NightOut
//
//  Created by Dan Berenholtz on 6/24/12.
//  Copyright (c) 2012 WhoWentOut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoSliderViewController : UIViewController<UIScrollViewDelegate>

@property (retain) UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (retain) UILabel *pageLabel;
@property (nonatomic, retain) NSArray *urls;

@property (readonly) NSInteger currentPage;
@property (readonly) NSInteger totalPageCount;

- (void)loadPhotoUrls:(NSArray *)imageUrls;
- (IBAction)handleImageTap:(UITapGestureRecognizer *)recognizer;

@end
