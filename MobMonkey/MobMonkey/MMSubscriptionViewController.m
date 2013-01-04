//
//  MMSubscriptionViewController.m
//  MobMonkey
//
//  Created by Scott Menor on 12/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMSubscriptionViewController.h"
#import <Parse/Parse.h>

@interface MMSubscriptionViewController ()

@end

@implementation MMSubscriptionViewController

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
    [self.navigationController.navigationBar setHidden:YES];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.navigationController.navigationBar setHidden:NO];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) dismissButtonTapped:(id)sender {
        [self.navigationController dismissModalViewControllerAnimated:YES];

}


- (IBAction)subscribeButtonTapped:(id)sender {
    [subscribeButton setEnabled:NO];
    [PFPurchase buyProduct:@"com.mobmonkey.MobMonkey.VK4524W4XL.1month" block:^(NSError *error) {
        if (!error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Subscription Complete" message:@"Subscription successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:[NSString stringWithFormat:@"%@ subscribed", [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]]];
            
            [appDelegate.adView setHidden:YES];
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
        }
        else {
            NSLog (@"%@",[error localizedDescription]);
        }
        
    }];

}


@end
