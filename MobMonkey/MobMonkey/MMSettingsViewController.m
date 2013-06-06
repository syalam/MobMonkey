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
#import "MMTermsOfUseViewController.h"


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
    
    
   _settingItems = [NSArray arrayWithObjects: @"Social Networks", @"My Interests", @"Requests",@"My Activity", nil];
    
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
    
    //Deselect Row
    NSIndexPath*    selection = [self.tableView indexPathForSelectedRow];
    if (selection) {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _settingItems.count;
            break;
            
        case 1:
            return 1;
            break;
        default:
            return 0;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.section == 0){
        
        cell.textLabel.text = [_settingItems objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }else if(indexPath.section == 1){
        
        cell.textLabel.text = @"Log Out";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    }else if(indexPath.section == 1) {
        cell.backgroundColor = [UIColor colorWithRed:0.871 green:0.131 blue:0.144 alpha:1.000];
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0: {
                MMSocialNetworksViewController *socialNetworksVC = [[MMSocialNetworksViewController alloc]initWithNibName:@"MMSocialNetworksViewController" bundle:nil];
                socialNetworksVC.title = @"Social Networks";
                [self.navigationController pushViewController:socialNetworksVC animated:YES];
            }
                break;
            case 1: {
                MMCategoryViewController *categoryVC = [[MMCategoryViewController alloc] initWithNibName:@"MMCategoryViewController" bundle:nil];
                categoryVC.title = @"My Interests";
                [self.navigationController pushViewController:categoryVC animated:YES];
            }
                break;
            case 2: {
                //TODO Requests
            }
                break;
            case 3: {
                //TODO My Activity
            } 
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1){
        [self signInButtonTapped:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    
    //
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

#pragma mark - UINavBar Button Tap Methods
- (IBAction)signInButtonTapped:(id)sender {
    [SVProgressHUD showWithStatus:@"Signing Out"];
    [MMAPI signOut:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userName"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"oAuthToken"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"facebookEnabled"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"twitterEnabled"];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"oauthUser"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"oauthToken"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"oauthProvider"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[MMMyInfo myInfo] eraseInfo];
        
        [[MMClientSDK sharedSDK]signInScreen:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userName"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"oAuthToken"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"facebookEnabled"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"twitterEnabled"];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"oauthUser"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"oauthToken"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"oauthProvider"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [[MMMyInfo myInfo] eraseInfo];
        
        [[MMClientSDK sharedSDK]signInScreen:self];
    }];
    
}


@end
