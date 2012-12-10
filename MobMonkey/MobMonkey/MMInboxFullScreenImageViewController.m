//
//  MMInboxFullScreenImageViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/4/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMInboxFullScreenImageViewController.h"

@interface MMInboxFullScreenImageViewController ()

@end

@implementation MMInboxFullScreenImageViewController

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
  
  if (![[NSUserDefaults standardUserDefaults]boolForKey:@"subscribedUser"]) {
    // for an unsubscribed user - how many times they viewed a specific media, Free user can view something 10 times a month, and then start showing ads
    
    // Every 5th view will result in a pop-up ad on the client
    
    // After 5 views always show the subscription modal

    // asdf

    NSString *viewsKey = [NSString stringWithFormat:@"%@_views", _imageUrl];
    NSArray *viewsArray = [[NSUserDefaults standardUserDefaults] arrayForKey:viewsKey];

    // add view to viewsArray
    // get view count for this month
    // if viewCount for this month > 10, show ads
    // viewCountForMonth %5 -> popup ad
    // viewCount > 5 - show subscription modal
    
//    NSInteger viewNumber = [[[NSUserDefaults standardUserDefaults]objectForKey:viewNumberKey] intValue];
    
  }
    [imageWebView sizeToFit];
    [imageWebView setContentMode:UIViewContentModeScaleAspectFit];
    [imageWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_imageUrl]]];
    
    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Tap Methods

@end
