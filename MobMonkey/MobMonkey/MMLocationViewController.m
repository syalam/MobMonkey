//
//  MMLocationViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/2/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMLocationViewController.h"
#import "MMRequestViewController.h"
#import "MMNotificationSettingsViewController.h"
#import "MMFullScreenImageViewController.h"
#import "MMSetTitleImage.h"
#import "MMLoginViewController.h"
#import "MMMapViewController.h"

@interface MMLocationViewController ()

@end

@implementation MMLocationViewController

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
    
    //self.navigationItem.titleView = [[MMSetTitleImage alloc]setTitleImageView];
    
    //setup scrollview size
    [_scrollView setContentSize:CGSizeMake(320, 740)];
    
    //set background color
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background~iphone"]]];
    
    [_overlayButtonView setAlpha:0];
    
    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"row%dFlagged", self.rowIndex]]) {
        [self.flagButton setBackgroundColor:[UIColor blueColor]];
    }
    else {
        [self.flagButton setBackgroundColor:[UIColor clearColor]];
    }

    if ([[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"row%dBookmarked", self.rowIndex]]) {
        [self.bookmarkButton setTitle:@"Bookmark" forState:UIControlStateNormal];
    }
    else {
        [self.bookmarkButton setTitle:@"Unbookmark" forState:UIControlStateNormal];
    }

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

#pragma mark - UINavBar Button Tap method
- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"4808675309";
            break;
        case 1:
            cell.textLabel.numberOfLines = 2;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.text = @"750 W. Baseline Rd.\nTempe, AZ 85283";
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            NSString *urlString = @"tel:4808675309";
            NSString *escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@", escaped);
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:escaped]];
        }
            break;
        case 1: {
            MMMapViewController *mmmVc = [[MMMapViewController alloc]initWithNibName:@"MMMapViewController" bundle:nil];
            mmmVc.address = @"750 W. Baseline Rd. Tempe, AZ 85283";
            [self.navigationController pushViewController:mmmVc animated:YES];
        }
            
        default:
            break;
    }
   
}
- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
            return 88;
            break;
        default:
            return 44;
            break;
    }
}

#pragma mark - IBAction Methods
- (IBAction)makeRequestButtonTapped:(id)sender {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
        MMRequestViewController *requestVC = [[MMRequestViewController alloc]initWithNibName:@"MMRequestViewController" bundle:nil];
        requestVC.title = @"Make a Request";
        UINavigationController *requestNavC = [[UINavigationController alloc]initWithRootViewController:requestVC];
        [self.navigationController presentViewController:requestNavC animated:YES completion:NULL];
    }
    else {
        MMLoginViewController *loginVC = [[MMLoginViewController alloc]initWithNibName:@"MMLoginViewController" bundle:nil];
        UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self.navigationController presentViewController:navC animated:YES completion:NULL];
    }
}

- (IBAction)toggleButtonTapped:(id)sender {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationDelegate: self];
    if (_overlayButtonView.alpha == 0) {
        [_overlayButtonView setAlpha:1];
    }
    else {
        [_overlayButtonView setAlpha:0];
    }
    [UIView commitAnimations];
}

- (IBAction)notificationSettingsButtonTapped:(id)sender {
    MMNotificationSettingsViewController *noticiationSettingsVC = [[MMNotificationSettingsViewController alloc]initWithNibName:@"MMNotificationSettingsViewController" bundle:nil];
    noticiationSettingsVC.delegate = self;
    [self.navigationController pushViewController:noticiationSettingsVC animated:YES];
}

- (IBAction)shareButtonTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", @"Notification Settings", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)enlargeButtonTapped:(id)sender {
    MMFullScreenImageViewController *fullScreenVC = [[MMFullScreenImageViewController alloc]initWithNibName:@"MMFullScreenImageViewController" bundle:nil];
    fullScreenVC.imageToDisplay = _locationLatestImageView.image;
    fullScreenVC.rowIndex = self.rowIndex;
    UINavigationController *fullScreenNavC = [[UINavigationController alloc]initWithRootViewController:fullScreenVC];
    fullScreenNavC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:fullScreenNavC animated:YES completion:NULL];
}

- (IBAction)flagButtonTapped:(id)sender {
    if (![[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"row%dFlagged", self.rowIndex]]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:[NSString stringWithFormat:@"row%dFlagged", self.rowIndex]];
        [self.flagButton setBackgroundColor:[UIColor blueColor]];
    }
    else {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:[NSString stringWithFormat:@"row%dFlagged", self.rowIndex]];
        [self.flagButton setBackgroundColor:[UIColor clearColor]];
    }
    
}

- (IBAction)bookmarkButtonTapped:(id)sender {
    if (![[NSUserDefaults standardUserDefaults]boolForKey:[NSString stringWithFormat:@"row%dBookmarked", self.rowIndex]]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:[NSString stringWithFormat:@"row%dBookmarked", self.rowIndex]];
        [self.bookmarkButton setTitle:@"Bookmark" forState:UIControlStateNormal];
    }
    else {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:[NSString stringWithFormat:@"row%dBookmarked", self.rowIndex]];
        [self.bookmarkButton setTitle:@"Unbookmark" forState:UIControlStateNormal];
    }

}

#pragma mark - Action Sheet Delegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2: {
            MMNotificationSettingsViewController *notificationSettingsVC = [[MMNotificationSettingsViewController alloc]initWithNibName:@"MMNotificationSettingsViewController" bundle:nil];
            UINavigationController *notificationSettingsNavC = [[UINavigationController alloc]initWithRootViewController:notificationSettingsVC];
            [self.navigationController presentViewController:notificationSettingsNavC animated:YES completion:NULL];
        }
            break;
        default:
            break;
    }
}

#pragma mark - MMNotificationSettings delegate methods
- (void)selectedSetting:(id)selectedNotificationSetting {
    
}

@end
