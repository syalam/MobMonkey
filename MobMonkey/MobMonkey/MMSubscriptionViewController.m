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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) dismiss;
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)subscribeButtonTapped:(id)sender {
    [PFPurchase buyProduct:@"com.mobmonkey.MobMonkey.VK4524W4XL.subscribed" block:^(NSError *error) {
        if (!error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Subscription Complete" message:@"Subscription successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            NSLog (@"%@",[error localizedDescription]);
        }
        
    }];

}


@end
