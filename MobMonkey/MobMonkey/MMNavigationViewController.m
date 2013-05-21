//
//  MMNavigationViewController.m
//  MobMonkey_LVF
//
//  Created by Michael Kral on 4/18/13.
//  Copyright (c) 2013 MobMonkey. All rights reserved.
//

#import "MMNavigationViewController.h"
#import "ECSlidingViewController.h"

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
    
    if(self = [super initWithRootViewController:rootViewController]){
        
        self.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.558 blue:0.286 alpha:1.000];
        
        //UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"whiteList.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(menuButtonPressed:)];
        
        UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithTitle:@"MENU" style:UIBarButtonItemStyleBordered target:self action:@selector(menuButtonPressed:)];
        
        rootViewController.navigationItem.leftBarButtonItem = menuItem;
    }
    
    return self;
    
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
}

@end
