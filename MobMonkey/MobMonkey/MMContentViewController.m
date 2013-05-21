//
//  MMContentViewController.m
//  MobMonkey_LVF
//
//  Created by Michael Kral on 4/18/13.
//  Copyright (c) 2013 MobMonkey. All rights reserved.
//

#import "MMContentViewController.h"
#import "ECSlidingViewController.h"
#import "MMSlideMenuViewController.h"

@interface MMContentViewController ()

@end

@implementation MMContentViewController

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
	// Do any additional setup after loading the view.
    
    
    

    //}
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[MMSlideMenuViewController class]]){
        
        MMSlideMenuViewController *menuViewController = [[MMSlideMenuViewController alloc] initWithNibName:@"MMSlideMenuViewController" bundle:nil];
        self.slidingViewController.underLeftViewController = menuViewController;   }
    
    //if(self.slidingViewController.panGesture){
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
