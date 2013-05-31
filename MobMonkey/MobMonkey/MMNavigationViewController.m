//
//  MMNavigationViewController.m
//  MobMonkey_LVF
//
//  Created by Michael Kral on 4/18/13.
//  Copyright (c) 2013 MobMonkey. All rights reserved.
//

#import "MMNavigationViewController.h"
#import "ECSlidingViewController.h"
#import "UIBarButtonItem+NoBorder.h"
#import "MMSlideMenuViewController.h"
@interface MMNavigationViewController ()

@property (nonatomic, strong) UIBarButtonItem *leftMenuButton;

@end

@implementation MMNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithRootViewController:(UIViewController *)rootViewController{
    
    if(self = [super initWithNavigationBarClass:[MMNavigationBar class] toolbarClass:[UIToolbar class]]){
        
        [self setViewControllers:[NSArray arrayWithObject:rootViewController]];
        
        
        //self.navigationBar.backgroundColor = [UIColor redColor];
        ((MMNavigationBar *)self.navigationBar).translucentFactor = 0.4;
        
        
        self.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.558 blue:0.286 alpha:1.000];
        
        rootViewController.view.layer.shadowOpacity = 0.75f;
        rootViewController.view.layer.shadowRadius = 10.0f;
        rootViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
        
        //UIBarButtonItem *menuItem = [UIBarButtonItem alloc] initw
        
        UIBarButtonItem *menuItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"list-shadow"] selectedImage:nil target:self action:@selector(menuButtonPressed:)];
        rootViewController.navigationItem.leftBarButtonItem = menuItem;
        
        
    }
    
    return self;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MMSlideMenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [[MMSlideMenuViewController alloc] initWithNibName:@"MMSlideMenuViewController" bundle:nil];

    }
    
    self.slidingViewController.topViewController.view.layer.shadowOpacity = 0.75f;
    self.slidingViewController.topViewController.view.layer.shadowRadius = 10.0f;
    self.slidingViewController.topViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)menuButtonPressed:(id)sender{
    [self.slidingViewController anchorTopViewTo:ECRight];
    [self.view endEditing:YES];
}

@end
