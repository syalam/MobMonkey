//
//  MMSocialNetworksViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/11/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMSocialNetworksViewController.h"
#import "MMSocialNetworkModel.h"

@interface MMSocialNetworksViewController ()
@property (nonatomic, assign) OAuthProvider loginProvider;
@end

@implementation MMSocialNetworksViewController

@synthesize loginProvider = _loginProvider;

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
    NSArray *sectionOneArray = [[NSArray alloc]initWithObjects:@"Facebook", @"Twitter", nil];
    
    NSArray *tableContentArray = [NSArray arrayWithObjects:sectionOneArray, nil];
    
    [self setContentList:tableContentArray];
    
    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;


}
-(void)setSwitchValues{
    NSString *loginNetwork = [[NSUserDefaults standardUserDefaults] objectForKey:@"oauthProvider"];
    
    if([loginNetwork isEqualToString:@"twitter"]){
        self.loginProvider = OAuthProviderTwitter;
    }else if([loginNetwork isEqualToString:@"facebook"]){
        self.loginProvider = OAuthProviderFacebook;
    }else{
        self.loginProvider = OAuthProviderNone;
    }
    [self.tableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setSwitchValues];
    
    //[SVProgressHUD dismiss];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _contentList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionContent = [_contentList objectAtIndex:section];
    return sectionContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionContent = [_contentList objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContent objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UISwitch *connectedSwitch;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
         connectedSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        [connectedSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView = connectedSwitch;
        
    }else{
        connectedSwitch = (UISwitch*)cell.accessoryView;
    }
    cell.accessoryView.tag = indexPath.row;
    
    cell.textLabel.text = contentForThisRow;
    switch (indexPath.row) {
        case 0:
            
            if(self.loginProvider == OAuthProviderFacebook){
                connectedSwitch.enabled = NO;
                cell.textLabel.textColor = [UIColor grayColor];
                cell.detailTextLabel.text = @"Needed for Authentication";
            }else{
                connectedSwitch.enabled = YES;
                cell.textLabel.textColor = [UIColor blackColor];
                cell.detailTextLabel.text = nil;
            }
            
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"facebookEnabled"]) {
                connectedSwitch.on = YES;
            }
            else {
               connectedSwitch.on = NO;
            }
            
           
            
            break;
        case 1:
            
            if(self.loginProvider == OAuthProviderTwitter){
                connectedSwitch.enabled = NO;
                cell.textLabel.textColor = [UIColor grayColor];
                cell.detailTextLabel.text = @"Needed for Authentication";
            }else{
                connectedSwitch.enabled = YES;
                cell.textLabel.textColor = [UIColor blackColor];
                cell.detailTextLabel.text = nil;
            }
        
            
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"twitterEnabled"]) {
                connectedSwitch.on = YES;
            }
            else {
                connectedSwitch.on = NO;
            }
            
            

            break;
        default:
            break;
    }
    
    // Configure the cell...
    
    return cell;
}
-(void)switchValueChanged:(UISwitch *)aSwitch{
    
    if(aSwitch.tag == 0){
        NSLog(@"Switch One");
        if([aSwitch isOn]){
            NSLog(@"ON");
            [SVProgressHUD showWithStatus:@"Authenticating"];
            [MMSocialNetworkModel authenticateFacebookWithSuccess:^{
                
                [SVProgressHUD showSuccessWithStatus:@"Authenticated Successfully"];
                
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"facebookEnabled"];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self.tableView reloadData];
                
                return;
            } failure:^(NSError *error) {
                
                [SVProgressHUD showErrorWithStatus:@"Failed Authentication"];
                
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"facebookEnabled"];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self.tableView reloadData];
                
                return ;
            }];
        }else{
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"facebookEnabled"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [SVProgressHUD showSuccessWithStatus:@"Disconnected"];
            
            [self.tableView reloadData];

        }
        
    }else if(aSwitch.tag == 1){
        if([aSwitch isOn]){
            NSLog(@"ON");
            [SVProgressHUD showWithStatus:@"Authenticating"];
            [MMSocialNetworkModel authenticateTwitterWithSuccess:^{
                
                [SVProgressHUD showSuccessWithStatus:@"Authenticated Successfully"];
                
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"twitterEnabled"];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self.tableView reloadData];
                
                return;
            } failure:^(NSError *error) {
                
                [SVProgressHUD showErrorWithStatus:@"Failed Authentication"];
                
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"twitterEnabled"];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self.tableView reloadData];
                
                return ;
            }];
        }else{
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"twitterEnabled"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [SVProgressHUD showSuccessWithStatus:@"Disconnected"];
            
            [self.tableView reloadData];

        }
    }
    
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
/*-(void)socialNetworkCell:(MMSocialNetworksCell *)cell switchChanges:(UISwitch *)sender {
    
    
    MMSocialNetworkModel *socialNetworkModel = [MMSocialNetworkModel authentication];
    
    switch (cell.cellType) {
        case OAuthProviderFacebook:
            if (sender.on) {
                [SVProgressHUD showWithStatus:@"Authenticating"];
                [socialNetworkModel authenticateFacebookWithSuccess:^{
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"facebookEnabled"];
                    [SVProgressHUD showSuccessWithStatus:@"Authenticated Successfully"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [self.tableView reloadData];
                    return;
                } failure:^(NSError *error) {
                    NSLog(@"Error: %@", error);
                    sender.on = NO;
                    [SVProgressHUD showErrorWithStatus:@"Failed Authentication"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [self.tableView reloadData];
                    return;
                }];
                
            }
            else {
                [SVProgressHUD showWithStatus:@"Disconnecting"];
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"facebookEnabled"];
                [SVProgressHUD showSuccessWithStatus:@"Disconnected"];
            }
            break;
        case OAuthProviderTwitter:
            if (sender.on) {
                [SVProgressHUD showWithStatus:@"Authenticating"];
                [socialNetworkModel authenticateTwitterWithSuccess:^{
                    
                    [SVProgressHUD showSuccessWithStatus:@"Authenticated Successfully"];
                    
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"twitterEnabled"];
                    
                    [[NSUserDefaults standardUserDefaults]synchronize];

                    [self.tableView reloadData];
                    
                    return;
                } failure:^(NSError *error) {
                    
                    [SVProgressHUD showErrorWithStatus:@"Failed Authentication"];
                    
                    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"twitterEnabled"];
                    
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    [self.tableView reloadData];
                    
                    return ;
                }];
            }
            else {
                [SVProgressHUD showWithStatus:@"Disconnecting"];
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"twitterEnabled"];
                [SVProgressHUD showSuccessWithStatus:@"Disconnected"];

            }
            break;
        default:
            break;
    }
    
}*/

#pragma mark - UINavBar Action Methods


@end
