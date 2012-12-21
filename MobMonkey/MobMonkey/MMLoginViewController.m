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
    //self.navigationItem.titleView = [[MMSetTitleImage alloc]setTitleImageView];
    self.title = @"Sign In";
    
    CGRect textFieldRect = CGRectMake(10, 10, 250, 30);
    
    emailTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    emailTextField.placeholder = @"Email Address";
    emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailTextField.autocorrectionType= UITextAutocorrectionTypeNo;
  if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
    emailTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
  }
    [[NSUserDefaults standardUserDefaults]setObject:emailTextField.text forKey:@"userName"];
  
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
            [[NSUserDefaults standardUserDefaults]setObject:emailTextField.text forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults]setObject:passwordTextField.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"subscribedUser"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [MMAPI getAllCategories:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@", responseObject);
                [[NSUserDefaults standardUserDefaults]setObject:responseObject forKey:@"allCategories"];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@", operation.responseString);
            }];
            
            NSMutableDictionary *checkinParams = [[NSMutableDictionary alloc]init];
            [checkinParams setObject:[NSNumber numberWithDouble:[[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"]doubleValue]] forKey:@"latitude"];
            [checkinParams setObject:[NSNumber numberWithDouble:[[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]doubleValue]]forKey:@"longitude"];
            
            [MMAPI checkUserIn:checkinParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@", @"Checked In");
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@", operation.responseString);
            }];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Could not log in"];
        }];
    }
}

- (IBAction)facebookButtonTapped:(id)sender {
    [MMAPI facebookSignIn];
}

- (IBAction)twitterButtonTapped:(id)sender {
    
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

#pragma mark MMAPIDelegate Methods
- (void)MMAPICallSuccessful:(id)response {
    NSLog(@"%@", response);
    [SVProgressHUD showSuccessWithStatus:@"Signed In"];
    [[NSUserDefaults standardUserDefaults]setObject:emailTextField.text forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults]setObject:passwordTextField.text forKey:@"password"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
- (void)MMAPICallFailed:(AFHTTPRequestOperation*)operation {
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
    NSString *responseString = [response valueForKey:@"description"];
    
    [SVProgressHUD showErrorWithStatus:responseString];
}

@end
