//
//  MMScheduleRequestViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMScheduleRequestViewController.h"

@interface MMScheduleRequestViewController ()

@end

@implementation MMScheduleRequestViewController

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
    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
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

#pragma mark - IBAction Methods
- (IBAction)scheduleItButtonTapped:(id)sender {
    NSLog(@"%@", _datePicker.date);
    [_delegate selectedScheduleDate:_datePicker.date recurring:_recurringSwitch.isOn];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UINavBar Methods
- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
