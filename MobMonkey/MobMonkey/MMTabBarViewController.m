//
//  MMTabBarViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/8/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMTabBarViewController.h"
#import "MMTrendingViewController.h"
#import "MMInboxViewController.h"
#import "MMSearchViewController.h"
#import "MMSettingsViewController.h"

@interface MMTabBarViewController ()

@end

@implementation MMTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Override point for customization after application launch.
        UIViewController *inboxVC = [[MMInboxViewController alloc] initWithNibName:@"MMInboxViewController" bundle:nil];
        UIViewController *searchVC = [[MMSearchViewController alloc]initWithNibName:@"MMSearchViewController" bundle:nil];
        UIViewController *trendingVC = [[MMTrendingViewController alloc] initWithNibName:@"MMTrendingViewController" bundle:nil];
        MMTrendingViewController *bookmarksVC = [[MMTrendingViewController alloc]initWithNibName:@"MMTrendingViewController" bundle:nil];
        UIViewController *settingsVC = [[MMSettingsViewController alloc]initWithNibName:@"MMSettingsViewController" bundle:nil];
        
        UINavigationController *inboxNavC = [[UINavigationController alloc]initWithRootViewController:inboxVC];
        UINavigationController *searchNavC = [[UINavigationController alloc]initWithRootViewController:searchVC];
        UINavigationController *trendingNavC = [[UINavigationController alloc]initWithRootViewController:trendingVC];
        UINavigationController *bookmarksNavC = [[UINavigationController alloc]initWithRootViewController:bookmarksVC];
        UINavigationController *settingsNavC = [[UINavigationController alloc]initWithRootViewController:settingsVC];
        
        inboxVC.title = @"Inbox";
        searchVC.title = @"Search";
        trendingVC.title = @"Trending";
        bookmarksVC.title = @"Bookmarks";
        settingsVC.title = @"Settings";
        
        bookmarksVC.sectionSelected = YES;
        bookmarksVC.bookmarkTab = YES;
        
        UITabBarItem *inboxBarItem = [[UITabBarItem alloc]initWithTitle:@"Inbox" image:nil tag:0];
        [inboxBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabBtn1Selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBtn1"]];
        [inboxBarItem setTitlePositionAdjustment:UIOffsetMake(0, 100)];
        [inboxNavC setTabBarItem:inboxBarItem];
        
        UITabBarItem *searchBarItem = [[UITabBarItem alloc]initWithTitle:@"Search" image:nil tag:0];
        [searchBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabBtn2Selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBtn2"]];
        [searchBarItem setTitlePositionAdjustment:UIOffsetMake(0, 100)];
        [searchNavC setTabBarItem:searchBarItem];
        
        UITabBarItem *trendingBarItem = [[UITabBarItem alloc]initWithTitle:@"Trending" image:nil tag:0];
        [trendingBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabBtn3Selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBtn3"]];
        [trendingBarItem setTitlePositionAdjustment:UIOffsetMake(0, 100)];
        [trendingNavC setTabBarItem:trendingBarItem];
        
        UITabBarItem *bookmarksBarItem = [[UITabBarItem alloc]initWithTitle:@"Favorites" image:nil tag:0];
        [bookmarksBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabBtn4Selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBtn4"]];
        [bookmarksBarItem setTitlePositionAdjustment:UIOffsetMake(0, 100)];
        [bookmarksNavC setTabBarItem:bookmarksBarItem];
        
        UITabBarItem *settingsBarItem = [[UITabBarItem alloc]initWithTitle:@"Settings" image:nil tag:0];
        [settingsBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabBtn5Selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabBtn5"]];
        [settingsBarItem setTitlePositionAdjustment:UIOffsetMake(0, 100)];
        [settingsNavC setTabBarItem:settingsBarItem];
        
        [self.view addSubview:self.tabBarController.view];
        
        
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

@end
