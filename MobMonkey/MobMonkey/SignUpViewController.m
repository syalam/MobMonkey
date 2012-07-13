//
//  SignUpViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController
@synthesize contentList = _contentList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Sign Up";

    CGRect textFieldRect = CGRectMake(10, 10, 250, 30);
    
    firstNameTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    firstNameTextField.placeholder = @"First Name";
    firstNameTextField.autocorrectionType= UITextAutocorrectionTypeNo;
    
    lastNameTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    lastNameTextField.placeholder = @"Last Name";
    lastNameTextField.autocorrectionType= UITextAutocorrectionTypeNo;
    
    emailTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    emailTextField.placeholder = @"Email Address";
    emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailTextField.autocorrectionType= UITextAutocorrectionTypeNo;
    
    passwordTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    passwordTextField.placeholder = @"Password";
    passwordTextField.secureTextEntry = YES;
    
    confirmPasswordTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    confirmPasswordTextField.placeholder = @"Confirm Password";
    confirmPasswordTextField.secureTextEntry = YES;
    
    _contentList = [[NSMutableArray alloc]initWithObjects:firstNameTextField, lastNameTextField, emailTextField, passwordTextField, confirmPasswordTextField, nil];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
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
    
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell.contentView addSubview:[_contentList objectAtIndex:indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - IBAction Methods
- (IBAction)signUpButtonClicked:(id)sender {
    NSString *message;
    if ([firstNameTextField.text isEqualToString:@""] || [firstNameTextField.text isKindOfClass:[NSNull class]]) {
        message = @"Please enter your first name";
    }
    else if ([lastNameTextField.text isEqualToString:@""] || [lastNameTextField.text isKindOfClass:[NSNull class]]) {
        message = @"Please enter your last name";
    }
    else if ([emailTextField.text isEqualToString:@""] || [emailTextField.text isKindOfClass:[NSNull class]]) {
        message = @"Please enter your email address";
    }
    else if ([passwordTextField.text isEqualToString:@""] || [passwordTextField.text isKindOfClass:[NSNull class]]) {
        message = @"Please enter a password";
    }
    else if (![passwordTextField.text isEqualToString:confirmPasswordTextField.text]) {
        message = @"The passwords you have entered to not match";
        passwordTextField.text = @"";
        confirmPasswordTextField.text = @"";
        
        [passwordTextField becomeFirstResponder];
    }
    else {
        PFUser *user = [PFUser user];
        [user setObject:firstNameTextField.text forKey:@"firstName"];
        [user setObject:lastNameTextField.text forKey:@"lastName"];
        user.username = emailTextField.text;
        user.email = emailTextField.text;
        user.password = passwordTextField.text;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                CFUUIDRef uuid;
                CFStringRef uuidStr;
                uuid = CFUUIDCreate(NULL);
                uuidStr = CFUUIDCreateString(NULL, uuid);
                
                NSString* uuidString = [NSString stringWithFormat:@"%@", uuidStr];
                NSLog(@"%@", uuidString);
                
                //Save UUID to user object
                [user setObject:uuidString forKey:@"uuid"];
                [user saveEventually];
                
                [PFPush subscribeToChannelInBackground:[NSString stringWithFormat:@"MM%@", uuidString]];

                [[AppDelegate getDelegate] initializeLocationManager];
                [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
            }
            else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                [self showAlertView:errorString];
            }
        }];
    }
    
    if (message) {
        [self showAlertView:message];
    }
    
    
}
- (IBAction)signInButtonClicked:(id)sender {
    LoginViewController *lvc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:lvc animated:YES];
}

- (void)cancelButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Helper Methods
- (void)showAlertView:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
