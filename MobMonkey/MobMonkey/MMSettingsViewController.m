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
    
    
    NSArray *sectionOneArray = [NSArray arrayWithObjects:@"My Info", @"Social Networks", @"Favorite Categories", nil];
    
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
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
        [_signInButton setTitle:@"Sign Out" forState:UIControlStateNormal];
    }
    else {
        [_signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
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
    
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = contentForThisRow;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            MMSignUpViewController *myInfoVc = [[MMSignUpViewController alloc]initWithNibName:@"MMSignUpViewController" bundle:nil];
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
            MMCategoryViewController *categoryVC = [[MMCategoryViewController alloc]initWithNibName:@"MMCategoryViewController" bundle:nil];
            categoryVC.title = @"Favorite Categories";
            [self.navigationController pushViewController:categoryVC animated:YES];
        }
            break;
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
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [_signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    }
    //otherwise allow the user to sign in but calling the sign in screen
    else {
        [[MMClientSDK sharedSDK]signInScreen:self];
    }
}

@end
