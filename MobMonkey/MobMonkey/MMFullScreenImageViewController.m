//
//  MMFullScreenImageViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMFullScreenImageViewController.h"

@interface MMFullScreenImageViewController ()

@property (nonatomic) NSInteger rowIndex;

@end

@implementation MMFullScreenImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
    
    [overlayButtonView setAlpha:1];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [SVProgressHUD dismiss];
    
    [imageView setImage:_imageToDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - IBAction Methods
- (IBAction)overlayToggleButtonTapped:(id)sender {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationDelegate: self];
    if (overlayButtonView.alpha == 0) {
        [overlayButtonView setAlpha:1];
    }
    else {
        [overlayButtonView setAlpha:0];
    }
    [UIView commitAnimations];
}
- (IBAction)closeButtonTapped:(id)sender {
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)likeButtonTapped:(id)sender {
    
}
- (IBAction)dislikeButtonTapped:(id)sender {
    
}
- (IBAction)flagButtonTapped:(id)sender {
    if (![[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"row%dFlagged", self.rowIndex]]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:[NSString stringWithFormat:@"row%dFlagged", self.rowIndex]];
        [self.flagButton setBackgroundColor:[UIColor blueColor]];
    }
    else {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:[NSString stringWithFormat:@"row%dFlagged", self.rowIndex]];
        [self.flagButton setBackgroundColor:[UIColor clearColor]];
    }

}
- (IBAction)shareButtonTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", @"Flag for Review", nil];
    [actionSheet showInView:self.view];

}

#pragma mark - UIGestureRecognizer Delegate methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

@end
