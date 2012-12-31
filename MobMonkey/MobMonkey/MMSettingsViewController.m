//
//  MMSettingsViewController.m
//  MobMonkey
//
//  Created by Sheehan Alam on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MMSettingsViewController.h"
#import "MMLoginViewController.h"
#import "MMSignUpViewController.h"
#import "MMCategoryViewController.h"
#import "MMSocialNetworksViewController.h"
#import "MMSetTitleImage.h"
#import "MMClientSDK.h"
#import "MMAppDelegate.h"
#import "MMSubscriptionViewController.h"


@interface MMSettingsViewController ()

@end

@implementation MMSettingsViewController
@synthesize contentList = _contentList;

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
    
    //self.navigationItem.titleView = [[MMSetTitleImage alloc]setTitleImageView];

    selectionDictionary = [[NSMutableDictionary alloc]init];
    
    
    NSArray *sectionOneArray = [NSArray arrayWithObjects:@"My Info", @"Social Networks", @"My Interests", @"Subscribe", nil];
    
    NSArray *tableContentsArray = [NSArray arrayWithObjects:sectionOneArray, nil];
    
    [self setContentList:[tableContentsArray mutableCopy]];
    
    self.title = @"Settings";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
        [[MMClientSDK sharedSDK]signInScreen:self];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return _contentList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = [_contentList objectAtIndex:section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArray = [_contentList objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = contentForThisRow;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            MMSignUpViewController *myInfoVc = [[MMSignUpViewController alloc] initWithNibName:@"MMSignUpViewController" bundle:nil];
            myInfoVc.title = @"My Info";
            [self.navigationController pushViewController:myInfoVc animated:YES];
        }
            break;
        case 1: {
            MMSocialNetworksViewController *socialNetworksVC = [[MMSocialNetworksViewController alloc]initWithNibName:@"MMSocialNetworksViewController" bundle:nil];
            socialNetworksVC.title = @"Social Networks";
            [self.navigationController pushViewController:socialNetworksVC animated:YES];
        }
            break;
        case 2: {
            MMCategoryViewController *categoryVC = [[MMCategoryViewController alloc] initWithNibName:@"MMCategoryViewController" bundle:nil];
            categoryVC.title = @"My Interests";
            [self.navigationController pushViewController:categoryVC animated:YES];
        }
            break;
        case 3: {
            MMSubscriptionViewController *subscriptionVC = [[MMSubscriptionViewController alloc]initWithNibName:@"MMSubscriptionViewController" bundle:nil];
            UINavigationController *subscriptionNavC = [[UINavigationController alloc]initWithRootViewController:subscriptionVC];
            [self.navigationController presentModalViewController:subscriptionNavC animated:YES];
        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Settings tableview action methods
- (void)toggleSocialSwitchTapped:(id)sender {
    UISwitch *toggleSwitch = sender;
    switch ([sender tag]) {
        case 0:
            if (toggleSwitch.on) {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"facebookEnabled"];
            }
            else {
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"facebookEnabled"];
            }
            break;
        case 1:
            if (toggleSwitch.on) {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"twitterEnabled"];
            }
            else {
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"twitterEnabled"];
            }
            break;
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - UINavBar Methods
- (IBAction)signInButtonTapped:(id)sender {
    //if user name exists, the user is signed in. On this button tap, the user should be signed out
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userName"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"oAuthToken"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
    }
    [[MMClientSDK sharedSDK]signInScreen:self];
}

@end
