//
//  MMSignUpViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MMSignUpViewController.h"
#import "MMLoginViewController.h"
#import "MMSetTitleImage.h"
#import "SVProgressHUD.h"
#import "AFHTTPRequestOperation.h"

@interface MMSignUpViewController ()

@end

@implementation MMSignUpViewController
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
    
    //self.navigationItem.titleView = [[MMSetTitleImage alloc]setTitleImageView];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background~iphone"]]];
    
    [_saveButton setHidden:YES];

    CGRect textFieldRect = CGRectMake(10, 10, 250, 30);
    
    _firstNameTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    _firstNameTextField.placeholder = @"First Name";
    _firstNameTextField.autocorrectionType= UITextAutocorrectionTypeNo;
    
    _lastNameTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    _lastNameTextField.placeholder = @"Last Name";
    _lastNameTextField.autocorrectionType= UITextAutocorrectionTypeNo;
    
    _emailTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    _emailTextField.placeholder = @"Email Address";
    _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailTextField.autocorrectionType= UITextAutocorrectionTypeNo;
    _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    _passwordTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    _passwordTextField.placeholder = @"Password";
    _passwordTextField.secureTextEntry = YES;
    
    _confirmPasswordTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    _confirmPasswordTextField.placeholder = @"Confirm Password";
    _confirmPasswordTextField.secureTextEntry = YES;
    
    _birthdayTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    _birthdayTextField.placeholder = @"Birthday";
    _birthdayTextField.enabled = NO;
    
    _genderTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    _genderTextField.placeholder = @"Gender";
    _genderTextField.enabled = NO;
    
    
     NSMutableArray *fieldsToDisplay = [[NSMutableArray alloc]initWithObjects:_firstNameTextField, _lastNameTextField, _emailTextField, _passwordTextField, _confirmPasswordTextField, _birthdayTextField, _genderTextField, nil];
    [self setContentList:fieldsToDisplay];
    
    if ([self.title isEqualToString:@"My Info"]) {
        [_signInButton setHidden:YES];
        [_signUpButton setHidden:YES];
        [_facebookButton setHidden:YES];
        [_twitterButton setHidden:YES];
        [_saveButton setHidden:NO];
    }
    
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
    switch (indexPath.row) {
        case 5:
            [self createBirthdayActionSheet];
            break;
        case 6:
            [self createGenderActionSheet];
            break;
        default:
            break;
    }
}

#pragma mark - IBAction Methods
- (IBAction)signUpButtonTapped:(id)sender {
    //NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:@"false", @"archived", nil];
    NSString *errorMessageText;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:1];
    if (!_firstNameTextField.text || [_firstNameTextField.text isEqualToString:@""]) {
        errorMessageText = @"Please enter your first name.";
    }
    else if (!_lastNameTextField.text || [_lastNameTextField.text isEqualToString:@""]) {
        errorMessageText = @"Please enter your first name.";
    }
    else if (!_emailTextField.text || [_emailTextField.text isEqualToString:@""]) {
        errorMessageText = @"Please enter your email address.";
    }
    else if (!_passwordTextField.text || [_passwordTextField.text isEqualToString:@""] || ![_passwordTextField.text isEqualToString:_confirmPasswordTextField.text]) {
        errorMessageText = @"The passwords you have entered do no match. Please re-enter your password.";
    }
    else if (!_birthdayTextField.text || [_birthdayTextField.text isEqualToString:@""]) {
        errorMessageText = @"Please enter your birthday.";
    }
    else if (!_genderTextField.text || [_genderTextField.text isEqualToString:@""]) {
        errorMessageText = @"Please enter your gender.";
    }
    
    if (errorMessageText) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:errorMessageText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        //convert birthday field into unix epoch time
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // this is imporant - we set our input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSDate *birthday = [[NSDate alloc] init];
        // voila!
        birthday = [dateFormatter dateFromString:_birthdayTextField.text];
        
        NSTimeInterval birthdayUnixTime = birthday.timeIntervalSince1970;
        
        [params setObject:_firstNameTextField.text forKey:@"firstName"];
        [params setObject:_lastNameTextField.text forKey:@"lastName"];
        [params setObject:_emailTextField.text forKey:@"eMailAddress"];
        [params setObject:_passwordTextField.text forKey:@"password"];
        [params setObject:[NSNumber numberWithDouble:birthdayUnixTime] forKey:@"birthday"];
        if ([_genderTextField.text isEqualToString:@"Male"]) {
            [params setObject:[NSNumber numberWithInt:1] forKey:@"gender"];
        }
        else {
            [params setObject:[NSNumber numberWithInt:0] forKey:@"gender"];
        }
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"apnsToken"]) {
            [params setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"apnsToken"] forKey:@"deviceId"];
        }
        else {
            [params setObject:@"01238jkl123iu33bb93aa621864be0a927de9672cb13af16b0e9512398uiu123oiu" forKey:@"deviceId"];
        }
        [params setObject:@"iOS" forKey:@"deviceType"];

        [MMAPI sharedAPI].delegate = self;
        [[MMAPI sharedAPI]signUpNewUser:params];
    }
}

- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)facebookButtonTapped:(id)sender {
    [MMAPI sharedAPI].delegate = self;
    [[MMAPI sharedAPI] facebookSignIn];
}

- (IBAction)twitterButtonTapped:(id)sender {
    TwitterAccounts *twitter = [[TwitterAccounts alloc]init];
    twitter.delegate = self;
    [twitter fetchData];
}

- (IBAction)saveButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseDateButtonTapped:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:datePicker.date];
    _birthdayTextField.text = [NSString stringWithFormat:@"%@", dateString];
    [birthdayActionSheet dismissWithClickedButtonIndex:[sender tag] animated:YES];
}

- (void)cancelDateButtonTapped:(id)sender {
    [birthdayActionSheet dismissWithClickedButtonIndex:[sender tag] animated:YES];
}

#pragma mark - Helper Methods
- (void)showAlertView:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - Helper Classes
- (void)createBirthdayActionSheet {
    birthdayActionSheet = [[UIActionSheet alloc] init];
    [birthdayActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    UISegmentedControl *chooseButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Choose"]];
    chooseButton.momentary = YES;
    chooseButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    chooseButton.segmentedControlStyle = UISegmentedControlStyleBar;
    chooseButton.tintColor = [UIColor blackColor];
    chooseButton.tag = 0;
    [chooseButton addTarget:self action:@selector(chooseDateButtonTapped:) forControlEvents:UIControlEventValueChanged];
    [birthdayActionSheet addSubview:chooseButton];
    
    UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cancel"]];
    cancelButton.momentary = YES;
    cancelButton.frame = CGRectMake(10.0f, 7.0f, 50.0f, 30.0f);
    cancelButton.segmentedControlStyle = UISegmentedControlStyleBar;
    cancelButton.tintColor = [UIColor blackColor];
    cancelButton.tag = 0;
    [cancelButton addTarget:self action:@selector(cancelDateButtonTapped:) forControlEvents:UIControlEventValueChanged];
    [birthdayActionSheet addSubview:cancelButton];
    
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    [birthdayActionSheet addSubview:datePicker];
    
    if ([self.title isEqualToString:@"My Info"]) {
        [birthdayActionSheet showInView:self.tabBarController.tabBar];
    }
    else {
        [birthdayActionSheet showInView:self.view];
    }
    
    [birthdayActionSheet setBounds:CGRectMake(0,0,320, 500)];
}

- (void)createGenderActionSheet {
    UIActionSheet *genderActionSheet = [[UIActionSheet alloc]initWithTitle:@"Gender" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Male", @"Female", nil];
    if ([self.title isEqualToString:@"My Info"]) {
        [genderActionSheet showInView:self.tabBarController.tabBar];
    }
    else {
        [genderActionSheet showInView:self.view];
    }
}

#pragma mark - Action Sheet Delegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            _genderTextField.text = @"Male";
            break;
        case 1:
            _genderTextField.text = @"Female";
            break;
        default:
            break;
    }
}

#pragma mark - Twitter Accounts delegate
- (void)showAccounts:(UIActionSheet*)accounts {
    [accounts showInView:self.view];
}

#pragma mark - MMAPI Delegate Methods
- (void)mmAPICallSuccessful:(NSDictionary*)response {
    [[NSUserDefaults standardUserDefaults]setObject:_emailTextField.text forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults]setObject:_passwordTextField.text forKey:@"password"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
- (void)mmAPICallFailed:(AFHTTPRequestOperation*)operation {
    NSString *responseString = operation.responseString;
    NSLog(@"%@", responseString);
}

@end
