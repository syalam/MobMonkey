//
//  MMFullScreenImageViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMFullScreenImageViewController.h"

@interface MMFullScreenImageViewController ()

@end

@implementation MMFullScreenImageViewController

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
    [self.navigationController setNavigationBarHidden:YES];
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
    
    [overlayButtonView setAlpha:1];
    /*imageView.image = _imageToDisplay;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"row%dFlagged", self.rowIndex]]) {
        [self.flagButton setBackgroundColor:[UIColor blueColor]];
    }
    else {
       [self.flagButton setBackgroundColor:[UIColor clearColor]];
    }*/
    
    
    webView.scalesPageToFit = YES;
    webView.contentMode = UIViewContentModeScaleAspectFill;
    webView.scrollView.contentSize = CGSizeMake(320, _imageToDisplay.size.height);
    [webView loadData:UIImageJPEGRepresentation(_imageToDisplay, 1) MIMEType:@"image/jpeg" textEncodingName:nil baseURL:nil];
    

    /*UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(overlayToggleButtonTapped:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    [webView addGestureRecognizer:tapGesture];*/
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}*/

/*- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

-(BOOL) shouldAutorotate {
    return YES;
}*/

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

@end
