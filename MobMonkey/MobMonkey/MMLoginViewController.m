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
        [params setObject:emailTextField.text forKey:@"eMailAddress"];
        [params setObject:passwordTextField.text forKey:@"password"];
        
        [SVProgressHUD showWithStatus:@"Signing In"];
        [MMAPI signInWithEmail:emailTextField.text password:passwordTextField.text provider:OAuthProviderNone success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"Signed In"];
            NSLog(@"%@", responseObject);
            [prefs setObject:emailTextField.text forKey:@"userName"];
            [prefs setObject:passwordTextField.text forKey:@"password"];
            [prefs synchronize];
            
            [self getAllCategories];
            
            [self checkInUser];
            
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

- (IBAction)facebookButtonTapped:(id)sender {
    NSArray *permissions = [NSArray arrayWithObjects:@"email", nil];
    [SVProgressHUD showWithStatus:@"Signing in with Facebook"];
    [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        if (session.isOpen) {
            FBRequest *me = [FBRequest requestForMe];
            [me startWithCompletionHandler: ^(FBRequestConnection *connection,
                                              NSDictionary<FBGraphUser> *my,
                                              NSError *error) {
                if (!error) {
                    NSLog(@"%@", my);
                    //TODO: send FB token to server call
                    NSString* accessToken = me.session.accessToken;
                    NSLog(@"%@", accessToken);
                    
                    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [my valueForKey:@"email"], @"eMailAddress",
                                            accessToken, @"oAuthToken", nil];
                    [[NSUserDefaults standardUserDefaults]setValue:[params valueForKey:@"eMailAddress"] forKey:@"userName"];
                    [[NSUserDefaults standardUserDefaults]setValue:[params valueForKey:@"oAuthToken"] forKey:@"oAuthToken"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [MMAPI facebookSignIn:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"%@", responseObject);
                        [prefs setBool:YES forKey:@"facebookEnabled"];
                        [prefs synchronize];
                        [self checkInUser];
                        [self getAllCategories];
                        [SVProgressHUD showSuccessWithStatus:@"Signed in with Facebook"];
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
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Unable to log you in. Please try again." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
        else {
            [SVProgressHUD dismiss];
            NSLog(@"%@", error);
        }
    }];
    
}

- (IBAction)twitterButtonTapped:(id)sender {
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
                    actionSheetCall = twitterAccountsActionSheetCall;
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
        NSLog(@"%@", responseObject);
        [prefs setObject:responseObject forKey:@"allCategories"];
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
        switch (actionSheetCall) {
            case twitterAccountsActionSheetCall: {
                ACAccount *account = [_twitterAccounts objectAtIndex:buttonIndex];
                
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                        account.username, @"eMailAddress",
                                        account.identifier, @"oAuthToken", nil];
                [[NSUserDefaults standardUserDefaults]setValue:[params valueForKey:@"eMailAddress"] forKey:@"userName"];
                [[NSUserDefaults standardUserDefaults]setValue:[params valueForKey:@"oAuthToken"] forKey:@"oAuthToken"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [MMAPI TwitterSignIn:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"%@", responseObject);
                    [SVProgressHUD showSuccessWithStatus:@"Signed in with Twitter"];
                    [[NSUserDefaults standardUserDefaults]setValue:[params valueForKey:@"eMailAddress"] forKey:@"userName"];
                    [[NSUserDefaults standardUserDefaults]setValue:[params valueForKey:@"oAuthToken"] forKey:@"oAuthToken"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"twitterEnabled"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [self checkInUser];
                    [self getAllCategories];
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
                break;
                
            default:
                break;
        }
    }
    
}

@end
