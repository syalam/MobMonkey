//
//  MMTermsOfUseViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 1/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMTermsOfUseViewController.h"

@interface MMTermsOfUseViewController ()

@end

@implementation MMTermsOfUseViewController

@synthesize acceptAction, rejectAction;

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
    
    self.title = @"Terms of Use";
    
    
    if(!self.requiresResponse){
        UIButton *backNavbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 30)];
        [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
        
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithCustomView:backNavbutton];
        self.navigationItem.leftBarButtonItem = backButton;
    } else {
        
        UIBarButtonItem *acceptButton = [[UIBarButtonItem alloc] initWithTitle:@"Accept" style:UIBarButtonItemStylePlain target:self action:@selector(acceptButtonTapped:)];
        acceptButton.tintColor = [UIColor colorWithRed:116.0/255.0
                                                 green:60.0/225.0
                                                  blue:20.0/255.0
                                                 alpha:1.0];
        self.navigationItem.rightBarButtonItem = acceptButton;
        
        UIBarButtonItem *rejectButton = [[UIBarButtonItem alloc] initWithTitle:@"Reject" style:UIBarButtonItemStylePlain target:self action:@selector(rejectButtonTapped:)];
        rejectButton.tintColor = [UIColor colorWithRed:116.0/255.0
                                                 green:60.0/225.0
                                                  blue:20.0/255.0
                                                 alpha:1.0];
        self.navigationItem.leftBarButtonItem = rejectButton;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Methods
- (void)backButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

-(void)acceptButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if(self.acceptAction){
        acceptAction();
    }
}

-(void)rejectButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if(self.rejectAction){
        rejectAction();
    }
}

@end
