//
//  MMSubscriptionViewController.m
//  MobMonkey
//
//  Created by Scott Menor on 12/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMSubscriptionViewController.h"
#import "AdWhirlView.h"
#import "MMAPI.h"


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
    
    appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(dismissButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"mmSubscribed"]){
       // [subscribeButton setEnabled:NO];
    }

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
    [SVProgressHUD dismiss];
        [self.navigationController dismissModalViewControllerAnimated:YES];

}


- (IBAction)subscribeButtonTapped:(id)sender {
    
    
    NSString *partnerID = [[NSUserDefaults standardUserDefaults] objectForKey:@"mmPartnerId"];
    NSString *userEmailID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userName"];
    
    NSLog(@"User: %@ Partner:%@", userEmailID, partnerID);
    if(partnerID && userEmailID){
        
        [SVProgressHUD showWithStatus:@"Subscribing..."];
        
        
        [MMAPI subscribeUserEmail:userEmailID partnerId:partnerID success:^{
            [subscribeButton setEnabled:NO];
            
            [SVProgressHUD showSuccessWithStatus:@"You are subscribed!"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"mmSubscribed"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Failed to subscribe"];
            NSLog(@"error: %@", error);
        }];
        
    }
    

}


@end
