//
//  ImageDetailViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/27/12.
//
//

#import "ImageDetailViewController.h"

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
    [_webView setScalesPageToFit:YES];
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

@end
