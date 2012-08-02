//
//  ImageDetailViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/27/12.
//
//

#import "ImageDetailViewController.h"
#import "SVProgressHUD.h"

@interface ImageDetailViewController ()

@end

@implementation ImageDetailViewController

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
    [_webView setScalesPageToFit:YES];
    
    if (_imageUrl) {
        NSLog(@"%@", _imageUrl);
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_imageUrl]]];
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonTapped:)];
    self.navigationItem.leftBarButtonItem = backButton;
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

#pragma mark - UIWebView Delegate methods
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismissWithError:@"Error"];
}

#pragma mark - Helper Methods
- (void)loadImage:(PFObject*)notificationObject {
    PFQuery *queryForImage = [PFQuery queryWithClassName:@"locationImages"];
    [queryForImage whereKey:@"notificationObject" equalTo:notificationObject];
    [queryForImage findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error){
        if (!error) {
            if (objects.count > 0) {
                PFObject *locationImageObject = [objects objectAtIndex:0];
                PFFile *imageFile = [locationImageObject objectForKey:@"image"];
                NSString *url = imageFile.url;
                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
            }
        }
    }];
}

- (void)loadImageFromUrl:(NSString*)urlString {
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

#pragma mark - Nav Bar Action Methods
- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
