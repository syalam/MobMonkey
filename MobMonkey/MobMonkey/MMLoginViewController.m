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
    
    passwordTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    passwordTextField.placeholder = @"Password";
    passwordTextField.secureTextEntry = YES;
    
    _contentList = [[NSMutableArray alloc]initWithObjects:emailTextField, passwordTextField, nil];

    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
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
            [SVProgressHUD dismissWithSuccess:@"Signed In"];
            [[NSUserDefaults standardUserDefaults]setObject:emailTextField.text forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults]setObject:passwordTextField.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismissWithError:@"Could not log in"];
        }];
    }
}

- (IBAction)facebookButtonTapped:(id)sender {
    [MMAPI sharedAPI].delegate = self;
    [[MMAPI sharedAPI]facebookSignIn];
}

- (IBAction)twitterButtonTapped:(id)sender {
    
}

- (IBAction)signUpButtonClicked:(id)sender {
    //show the sign up screen
    [[MMClientSDK sharedSDK]signUpScreen:self];
}

- (void)backButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Helper Methods
- (void)showAlertView:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark MMAPIDelegate Methods
- (void)MMAPICallSuccessful:(id)response {
    NSLog(@"%@", response);
    [SVProgressHUD dismissWithSuccess:@"Signed In"];
    [[NSUserDefaults standardUserDefaults]setObject:emailTextField.text forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults]setObject:passwordTextField.text forKey:@"password"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
- (void)MMAPICallFailed:(AFHTTPRequestOperation*)operation {
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
    NSString *responseString = [response valueForKey:@"description"];
    
    [SVProgressHUD dismissWithError:responseString];
}

@end
