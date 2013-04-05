//
//  LoginViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MMLoginViewController.h"
#import "MMSignUpViewController.h"
#import "MMSetTitleImage.h"
#import "SVProgressHUD.h"
#import "MMClientSDK.h"
#import "UIAlertView+Blocks.h"
#import "MMTermsOfUseViewController.h"

@interface MMLoginViewController () {
    UITextField *emailTextField;
    UITextField *passwordTextField;
}

@property (nonatomic, retain) NSMutableArray *contentList;

- (void)showAlertView:(NSString*)message;

@end

@implementation MMLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    prefs = [NSUserDefaults standardUserDefaults];
    //self.navigationItem.titleView = [[MMSetTitleImage alloc]setTitleImageView];
    self.title = @"Sign In";
    
    CGRect textFieldRect = CGRectMake(10, 10, 250, 30);
    
    emailTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    emailTextField.placeholder = @"Email Address";
    emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailTextField.autocorrectionType= UITextAutocorrectionTypeNo;
  if ([prefs objectForKey:@"userName"]) {
    emailTextField.text = [prefs objectForKey:@"userName"];
  }
    [prefs setObject:emailTextField.text forKey:@"userName"];
  
    passwordTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    passwordTextField.placeholder = @"Password";
    passwordTextField.secureTextEntry = YES;
    
    
    _contentList = [[NSMutableArray alloc]initWithObjects:emailTextField, passwordTextField, nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [SVProgressHUD dismiss];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.contentView addSubview:[_contentList objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

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

#pragma mark - IBAction Methods
- (IBAction)loginButtonClicked:(id)sender {
    NSString *errorMessage;
    if (!emailTextField.text || [emailTextField.text isEqualToString:@""]) {
        errorMessage = @"Please enter a valid email address";
    }
    else if (!passwordTextField.text || [passwordTextField.text isEqualToString:@""]) {
        errorMessage = @"Please enter your password";
    }
    if (errorMessage) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:@"iOS" forKey:@"deviceType"];
        [params setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"apnsToken"] forKey:@"deviceId"];
        [params setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"firstName"] forKey:@"firstName"];
        [params setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"lastName"] forKey:@"lastName"];
        [params setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"birthday"] forKey:@"birthday"];
        [params setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"gender"] forKey:@"gender"];

//        if(![params valueForKey:@"deviceId"])
//            [params setValue:[NSNumber numberWithInt:123] forKey:@"deviceId"];
        
        [SVProgressHUD showWithStatus:@"Signing In"];
        [MMAPI signInWithEmail:emailTextField.text password:passwordTextField.text params:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"Signed In"];
            NSLog(@"%@", responseObject);
            [prefs setObject:emailTextField.text forKey:@"userName"];
            [prefs setObject:passwordTextField.text forKey:@"password"];
            [prefs setBool:NO forKey:@"oauthUser"];
            [prefs synchronize];
            
            [self getAllCategories];
            
            [self checkInUser];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"checkForUpdatedCounts" object:nil];
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (operation.responseData) {
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
                if ([response valueForKey:@"description"]) {
                    NSString *responseString = [response valueForKey:@"description"];
                    
                    [SVProgressHUD showErrorWithStatus:responseString];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"Unable to login"];
                }
            }
        }];
    }
}

-(void)displayTermsOfUseAccept:(void(^)())accept reject:(void(^)())reject {
    MMTermsOfUseViewController *termsOfUseVC = [[MMTermsOfUseViewController alloc] initWithNibName:@"MMTermsOfUseViewController" bundle:nil];
    termsOfUseVC.requiresResponse = YES;
    
    termsOfUseVC.acceptAction = accept;
    termsOfUseVC.rejectAction = reject;
    
    UINavigationController *termsOfUseNVC = [[UINavigationController alloc] initWithRootViewController:termsOfUseVC];
    [self.navigationController presentViewController:termsOfUseNVC animated:YES completion:nil];
    
}

- (IBAction)facebookButtonTapped:(id)sender {
    
    [self displayTermsOfUseAccept:^{
        [[MMClientSDK sharedSDK]signInViaFacebook:nil presentingViewController:self];
    } reject:^{
        NSLog(@"The User Rejected the Terms of Use");
    }];
}

- (IBAction)twitterButtonTapped:(id)sender {
    
    [self displayTermsOfUseAccept:^{
        [SVProgressHUD showWithStatus:@"Loading Twitter Accounts"];
        ACAccountStore* accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountTypeTwitter = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [accountStore requestAccessToAccountsWithType:accountTypeTwitter options:nil completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                if (granted) {
                    _twitterAccounts = [accountStore accountsWithAccountType:accountTypeTwitter];
                    if (_twitterAccounts.count > 0) {
                        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Twitter Accounts on This Device" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                        for (NSInteger i = 0; i < _twitterAccounts.count; i++) {
                            ACAccount *account = [_twitterAccounts objectAtIndex:i];
                            [actionSheet addButtonWithTitle:account.username];
                        }
                        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
                        
                        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                        [actionSheet showInView:self.view];
                    }
                    else {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"There are no Twitter accounts enabled on this device. Please go into your iOS settings menu to add a Twitter account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"There are no Twitter accounts enabled on this device. Please go into your iOS settings menu to add a Twitter account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            });
        }];
    } reject:^{
        NSLog(@"The user reject the Terms of Use");
    }];
    
    
}

- (IBAction)signUpButtonClicked:(id)sender {
    //show the sign up screen
    [[MMClientSDK sharedSDK]signUpScreen:self];
}

#pragma mark - Helper Methods
- (void)showAlertView:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)checkInUser {
    NSMutableDictionary *checkinParams = [[NSMutableDictionary alloc]init];
    [checkinParams setObject:[NSNumber numberWithDouble:[[prefs objectForKey:@"latitude"]doubleValue]] forKey:@"latitude"];
    [checkinParams setObject:[NSNumber numberWithDouble:[[prefs objectForKey:@"longitude"]doubleValue]]forKey:@"longitude"];
    [MMAPI checkUserIn:checkinParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", @"Checked In");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
    }];
}

- (void)getAllCategories {
    [MMAPI getAllCategories:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@", responseObject);
        /*NSMutableArray *arrayToCleanUp = [responseObject mutableCopy];
        NSMutableArray *cleanArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dictionaryToCleanUp in arrayToCleanUp) {
            NSMutableDictionary *cleanDictionary = [[NSMutableDictionary alloc]init];
            id const nul = [NSNull null];
            for (NSString *key in dictionaryToCleanUp) {
                id const obj = [dictionaryToCleanUp valueForKey:key];
                if (nul == obj) {
                    [cleanDictionary setValue:@"" forKey:key];
                }
                else {
                    [cleanDictionary setValue:[dictionaryToCleanUp valueForKey:key] forKey:key];
                }
            }
            [cleanArray addObject:cleanDictionary];
        }*/
        
        [[NSUserDefaults standardUserDefaults]setObject:responseObject forKey:@"allCategories"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
    }];
}

#pragma mark MMAPIDelegate Methods
- (void)MMAPICallSuccessful:(id)response {
    NSLog(@"%@", response);
    [SVProgressHUD showSuccessWithStatus:@"Signed In"];
    [prefs setObject:emailTextField.text forKey:@"userName"];
    [prefs setObject:passwordTextField.text forKey:@"password"];
    [prefs synchronize];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
- (void)MMAPICallFailed:(AFHTTPRequestOperation*)operation {
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
    NSString *responseString = [response valueForKey:@"description"];
    
    [SVProgressHUD showErrorWithStatus:responseString];
}

#pragma mark - UIActionSheet Delegate methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (![buttonTitle isEqualToString:@"Cancel"]) {
        [SVProgressHUD showWithStatus:@"Signing in with Twitter"];
        
        ACAccount *account = [_twitterAccounts objectAtIndex:buttonIndex];
        [[MMClientSDK sharedSDK]signInViaTwitter:account presentingViewController:self];
    }
    
}

@end
