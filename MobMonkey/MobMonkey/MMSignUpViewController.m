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
#import "NSDate+JavaEpochTime.h"
#import "MMTermsOfUseViewController.h"

@interface MMSignUpViewController () {
    UIActionSheet *birthdayActionSheet;
    UIDatePicker *datePicker;
    NSTimeInterval birthdayUnixTime;
}

@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) UITextField *firstNameTextField;
@property (nonatomic, retain) UITextField *lastNameTextField;
@property (nonatomic, retain) UITextField *emailTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@property (nonatomic, retain) UITextField *confirmPasswordTextField;
@property (nonatomic, retain) UITextField *birthdayTextField;
@property (nonatomic, retain) UITextField *genderTextField;
@property (nonatomic, retain) UITextField *phoneNumberTextField;
@property (nonatomic, retain) NSMutableDictionary *userDictionary;


- (void)showAlertView:(NSString*)message;

@end

@implementation MMSignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.navigationItem.titleView = [[MMSetTitleImage alloc]setTitleImageView];

    //[_saveButton setHidden:YES];

    CGRect textFieldRect = CGRectMake(10, 10, 250, 30);
    
    _firstNameTextField = [[UITextField alloc] initWithFrame:textFieldRect];
    _firstNameTextField.placeholder = @"First Name";
    _firstNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    _lastNameTextField = [[UITextField alloc]initWithFrame:textFieldRect];
    _lastNameTextField.placeholder = @"Last Name";
    _lastNameTextField.autocorrectionType= UITextAutocorrectionTypeNo;
    
    _emailTextField = [[UITextField alloc] initWithFrame:textFieldRect];
    _emailTextField.placeholder = @"Email Address";
    _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailTextField.autocorrectionType= UITextAutocorrectionTypeNo;
    _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    _passwordTextField = [[UITextField alloc] initWithFrame:textFieldRect];
    _passwordTextField.placeholder = @"New Password";
    _passwordTextField.secureTextEntry = YES;
    
    _confirmPasswordTextField = [[UITextField alloc] initWithFrame:textFieldRect];
    _confirmPasswordTextField.placeholder = @"Confirm Password";
    _confirmPasswordTextField.secureTextEntry = YES;
    
    _birthdayTextField = [[UITextField alloc] initWithFrame:textFieldRect];
    _birthdayTextField.placeholder = @"Birthday";
    _birthdayTextField.enabled = NO;
    
    _genderTextField = [[UITextField alloc] initWithFrame:textFieldRect];
    _genderTextField.placeholder = @"Gender";
    _genderTextField.enabled = NO;
    
    
    NSMutableArray *fieldsToDisplay = [[NSMutableArray alloc]init];
    [fieldsToDisplay addObject:_firstNameTextField];
    [fieldsToDisplay addObject:_lastNameTextField];
    [fieldsToDisplay addObject:_emailTextField];

    if ((!_twitterSignIn) && (![[NSUserDefaults standardUserDefaults] valueForKey:@"twitterEnabled"]) && (![[NSUserDefaults standardUserDefaults] valueForKey:@"facebookEnabled"])) {
        [fieldsToDisplay addObject:_passwordTextField];
        [fieldsToDisplay addObject:_confirmPasswordTextField];
    }
    [fieldsToDisplay addObject:_birthdayTextField];
    [fieldsToDisplay addObject:_genderTextField];
    [self setContentList:fieldsToDisplay];

    if ([self.title isEqualToString:@"My Info"]) {
        [_signUpButton setHidden:YES];
        [_facebookButton setHidden:YES];
        [_twitterButton setHidden:YES];
        [termsOfUseAcceptanceButton setHidden:YES];
        [termsOfUseButton setHidden:YES];
        
        [MMAPI getUserOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.userDictionary = [[NSMutableDictionary alloc] initWithDictionary: responseObject];
            
            if (![[responseObject valueForKey:@"firstName"]isKindOfClass:[NSNull class]]) {
                self.firstNameTextField.text = [responseObject valueForKey:@"firstName"];
            }
            if (![[responseObject valueForKey:@"lastName"]isKindOfClass:[NSNull class]]) {
                self.lastNameTextField.text = [responseObject valueForKey:@"lastName"];
            }
            if (![[responseObject valueForKey:@"eMailAddress"]isKindOfClass:[NSNull class]]) {
                self.emailTextField.placeholder = [responseObject valueForKey:@"eMailAddress"];
                self.emailTextField.enabled = NO;
            }
            if (![[responseObject valueForKey:@"gender"]isKindOfClass:[NSNull class]]) {
                self.genderTextField.text = [[responseObject valueForKey:@"gender"] isEqualToNumber:@0] ? @"Female" : @"Male";
            }
            if (![[responseObject valueForKey:@"birthday"]isKindOfClass:[NSNull class]]) {
                NSString *birthdate = [NSDateFormatter localizedStringFromDate:[NSDate dateSinceJavaEpochTime:[responseObject valueForKey:@"birthday"]]
                                                                     dateStyle:NSDateFormatterLongStyle
                                                                     timeStyle:NSDateFormatterNoStyle];
                self.birthdayTextField.text = birthdate;
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Could not retrieve user info");
        }];
    }
    termsOfUseAccepted =  NO;
    //Add custom back button to the nav bar
    if (!_twitterSignIn)
    {
        UIButton *backNavbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 39, 30)];
        [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
        
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithCustomView:backNavbutton];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    else {
        termsOfUseAccepted = YES;
        [termsOfUseAcceptanceButton setHidden:YES];
        [termsOfUseButton setHidden:YES];
        _signUpButton.titleLabel.text = @"Sign In";
        [_facebookButton setHidden:YES];
        [_twitterButton setHidden:YES];
    }
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
    MMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
         cell = [[MMTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.contentView addSubview:[_contentList objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index;
    //adjust indcies for twitter login since password fields are not available
    if (_twitterSignIn || [[NSUserDefaults standardUserDefaults] valueForKey:@"twitterEnabled"] || [[NSUserDefaults standardUserDefaults] valueForKey:@"facebookEnabled"]) {
        index = indexPath.row + 2;
    }
    else {
        index = indexPath.row;
    }
    switch (index) {
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
    if (_twitterSignIn) {
        [self signUpTwitterUser];
    }
    else {
        [self signUpMMuser];
    }
}

- (IBAction)facebookButtonTapped:(id)sender {
    if (termsOfUseAccepted) {
        [[MMClientSDK sharedSDK]signInViaFacebook:nil presentingViewController:self];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Terms of use must be accepted before signing up" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (IBAction)twitterButtonTapped:(id)sender {
    if (termsOfUseAccepted) {
        [SVProgressHUD showWithStatus:@"Loading Twitter Accounts"];
        ACAccountStore* accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountTypeTwitter = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [accountStore requestAccessToAccountsWithType:accountTypeTwitter options:nil completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSLog(@"%@", error);
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
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Terms of use must be accepted before signing up" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

/*- (IBAction)saveButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}*/

- (void)chooseDateButtonTapped:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *dateString = [dateFormatter stringFromDate:datePicker.date];
    
    _birthdayTextField.text = [NSString stringWithFormat:@"%@", dateString];
    [birthdayActionSheet dismissWithClickedButtonIndex:[sender tag] animated:YES];
}

- (void)cancelDateButtonTapped:(id)sender {
    [birthdayActionSheet dismissWithClickedButtonIndex:[sender tag] animated:YES];
}

- (IBAction)termsOfUseAcceptanceButtonTapped:(id)sender {
    if (termsOfUseAccepted) {
        termsOfUseAccepted = NO;
        [termsOfUseAcceptanceButton setBackgroundImage:[UIImage imageNamed:@"checkBoxEmpty"] forState:UIControlStateNormal];
    }
    else {
        termsOfUseAccepted = YES;
        [termsOfUseAcceptanceButton setBackgroundImage:[UIImage imageNamed:@"CloseButton"] forState:UIControlStateNormal];
    }
}

- (IBAction)termsOfUseButtonTapped:(id)sender {
    MMTermsOfUseViewController *termsOfUseViewController = [[MMTermsOfUseViewController alloc]initWithNibName:@"MMTermsOfUseViewController" bundle:nil];
    termsOfUseViewController.title = @"Terms of use";
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:termsOfUseViewController];
    [self.navigationController presentViewController:navC animated:YES completion:NULL];
}

- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper Methods
- (void)showAlertView:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

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
    NSDate *minusTwentyYears = [NSDate dateWithTimeIntervalSinceNow:-(60*60*24*365.25*20)];
    [datePicker setDate:minusTwentyYears];
    
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
    actionSheetCall = genderActionSheetCall;
    if ([self.title isEqualToString:@"My Info"]) {
        [genderActionSheet showInView:self.tabBarController.tabBar];
    }
    else {
        [genderActionSheet showInView:self.view];
    }
}

- (void)checkInUser {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSNumber numberWithDouble:[[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"]doubleValue]] forKey:@"latitude"];
    [params setObject:[NSNumber numberWithDouble:[[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]doubleValue]]forKey:@"longitude"];
    [MMAPI checkUserIn:params
               success:^(AFHTTPRequestOperation *operation, id responseObject) {

                    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];

               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   if (operation.responseData) {
                       NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
                       if ([response valueForKey:@"description"]) {
                           NSString *responseString = [response valueForKey:@"description"];
                           
                           [SVProgressHUD showErrorWithStatus:responseString];
                       }
                       [[NSNotificationCenter defaultCenter]postNotificationName:@"checkForUpdatedCounts" object:nil];
                       [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
                   }
               }];
}

- (void)getAllCategories {
    [MMAPI getAllCategories:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@", responseObject);
        NSMutableArray *arrayToCleanUp = [responseObject mutableCopy];
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
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:cleanArray forKey:@"allCategories"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
    }];
}

- (void)signUpTwitterUser {
    NSString *errorMessageText;
    if (!_firstNameTextField.text || [_firstNameTextField.text isEqualToString:@""]) {
        errorMessageText = @"Please enter your first name.";
    }
    else if (!_lastNameTextField.text || [_lastNameTextField.text isEqualToString:@""]) {
        errorMessageText = @"Please enter your last name.";
    }
    else if (!_emailTextField.text || [_emailTextField.text isEqualToString:@""]) {
        errorMessageText = @"Please enter your email address.";
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
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // this is imporant - we set our input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSDate *birthday = [[NSDate alloc] init];
        // voila!
        birthday = [dateFormatter dateFromString:_birthdayTextField.text];
        
        NSTimeInterval bdayUnixTime = birthday.timeIntervalSince1970;
         NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:1];
        [params setObject:_firstNameTextField.text forKey:@"firstName"];
        [params setObject:_lastNameTextField.text forKey:@"lastName"];
        [params setObject:_emailTextField.text forKey:@"eMailAddress"];
        [params setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"apnsToken"] forKey:@"deviceId"];
        [params setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"userName"] forKey:@"providerUsername"];
        [params setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"oauthToken"] forKey:@"oauthToken"];
        [params setObject:[NSNumber numberWithDouble:bdayUnixTime] forKey:@"birthday"];
        if ([_genderTextField.text isEqualToString:@"Male"]) {
            [params setObject:[NSNumber numberWithInt:1] forKey:@"gender"];
        }
        else {
            [params setObject:[NSNumber numberWithInt:0] forKey:@"gender"];
        }
        
        [params setObject:@"iOS" forKey:@"deviceType"];
        
        [MMAPI registerTwitterUserDetails:params success:^(AFHTTPRequestOperation *operation, id responseObject) {            
//            [[NSUserDefaults standardUserDefaults]setValue:_firstNameTextField.text forKey:@"TwitterFirstName"];
//            [[NSUserDefaults standardUserDefaults]setValue:_lastNameTextField.text forKey:@"TwitterLastName"];
//            [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithInt:bdayUnixTime] forKey:@"TwitterBirthday"];
//            [[NSUserDefaults standardUserDefaults]setValue:[params valueForKey:@"gender"] forKey:@"TwitterGender"];
//            [[NSUserDefaults standardUserDefaults] synchronize];

            [SVProgressHUD showSuccessWithStatus:[responseObject valueForKey:@"description"]];
            [self checkInUser];
            [self getAllCategories];
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error description]];
        }];
        
        
    }
}

- (void)signUpMMuser {
    NSString *errorMessageText;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:1];
    if (!_firstNameTextField.text || [_firstNameTextField.text isEqualToString:@""]) {
        errorMessageText = @"Please enter your first name.";
    }
    else if (!_lastNameTextField.text || [_lastNameTextField.text isEqualToString:@""]) {
        errorMessageText = @"Please enter your last name.";
    }
    else if (!_emailTextField.text || [_emailTextField.text isEqualToString:@""]) {
        errorMessageText = @"Please enter your email address.";
    }
    else if (!_passwordTextField.text || [_passwordTextField.text isEqualToString:@""] || ![_passwordTextField.text isEqualToString:_confirmPasswordTextField.text]) {
        errorMessageText = @"The passwords you have entered do not match. Please re-enter your password.";
    }
    else if (!_birthdayTextField.text || [_birthdayTextField.text isEqualToString:@""]) {
        errorMessageText = @"Please enter your birthday.";
    }
    else if (!_genderTextField.text || [_genderTextField.text isEqualToString:@""]) {
        errorMessageText = @"Please enter your gender.";
    }
    else if (!termsOfUseAccepted) {
        errorMessageText = @"Terms of use must be accepted before signing up";
    }
    
    //convert birthday field into unix epoch time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *birthday = [[NSDate alloc] init];
    // voila!
    birthday = [dateFormatter dateFromString:_birthdayTextField.text];
    birthdayUnixTime = birthday.timeIntervalSince1970;
    
    [params setValue:_firstNameTextField.text forKey:@"firstName"];
    [params setValue:_lastNameTextField.text forKey:@"lastName"];
    [params setValue:_emailTextField.text forKey:@"eMailAddress"];
    [params setValue:_passwordTextField.text forKey:@"password"];
    [params setValue:[NSNumber numberWithDouble:birthdayUnixTime] forKey:@"birthday"];
    if ([_genderTextField.text isEqualToString:@"Male"]) {
        [params setValue:[NSNumber numberWithInt:1] forKey:@"gender"];
    }
    else {
        [params setValue:[NSNumber numberWithInt:0] forKey:@"gender"];
    }
    [params setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"apnsToken"] forKey:@"deviceId"];    
    [params setValue:@"iOS" forKey:@"deviceType"];
    
    if (errorMessageText) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:errorMessageText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        [SVProgressHUD showWithStatus:@"Signing Up"];
        
        [MMAPI signUpNewUser:params
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         [SVProgressHUD showSuccessWithStatus:@"Sign Up Successful"];
                         [[NSUserDefaults standardUserDefaults]setValue:_emailTextField.text forKey:@"userName"];
                         [[NSUserDefaults standardUserDefaults]setValue:_passwordTextField.text forKey:@"password"];
                         
                         /* Need firstName, lastName, birthday and gender for signIn */
                         [[NSUserDefaults standardUserDefaults]setValue:_firstNameTextField.text forKey:@"firstName"];
                         [[NSUserDefaults standardUserDefaults]setValue:_lastNameTextField.text forKey:@"lastName"];
                         [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithDouble:birthdayUnixTime] forKey:@"birthday"];
                         if ([_genderTextField.text isEqualToString:@"Male"]) {
                             [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithInt:1] forKey:@"gender"];
                         }
                         else {
                             [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithInt:0] forKey:@"gender"];
                         }
                         [[NSUserDefaults standardUserDefaults]synchronize];
                         
                         NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                         [params setObject:[NSNumber numberWithDouble:[[[NSUserDefaults standardUserDefaults]valueForKey:@"latitude"]doubleValue]] forKey:@"latitude"];
                         [params setObject:[NSNumber numberWithDouble:[[[NSUserDefaults standardUserDefaults]valueForKey:@"longitude"]doubleValue]]forKey:@"longitude"];
                         [self getAllCategories];
                         [self checkInUser];
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"%@", operation.responseString);
                         NSLog(@"Error: %@", error);
                         if (operation.responseData) {
                             NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
                             if ([response valueForKey:@"description"]) {
                                 NSString *responseString = [response valueForKey:@"description"];
                                 [SVProgressHUD showErrorWithStatus:responseString];
                             }
                             else {
                                 [SVProgressHUD showErrorWithStatus:@"Unable sign up"];
                             }
                         }
                     }];
    }
}


#pragma mark - Action Sheet Delegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if (![buttonTitle isEqualToString:@"Cancel"]) {        
        switch (actionSheetCall) {
            case twitterAccountsActionSheetCall: {
                [SVProgressHUD showWithStatus:@"Signing in with Twitter"];
                ACAccount *account = [_twitterAccounts objectAtIndex:buttonIndex];
                [[MMClientSDK sharedSDK]signInViaTwitter:account presentingViewController:self];
            }
                break;
            case genderActionSheetCall:
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
                break;
            default:
                break;
        }
    }
    
}

-(void) viewWillDisappear:(BOOL)animated {
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
        if (![self.title isEqualToString:@"My Info"])
        {
            [super viewWillDisappear:animated];

        }
        else
        {
            NSLog(@"%@", self.userDictionary);
            if (!self.userDictionary) {
                self.userDictionary = [[NSMutableDictionary alloc]init];
            }
            if ([[self.userDictionary valueForKey:@"firstName"] isKindOfClass:[NSNull class]]) {
                [self.userDictionary setValue:_firstNameTextField.text forKey:@"firstName"];
            }
            if ([[self.userDictionary valueForKey:@"lastName"]isKindOfClass:[NSNull class]]) {
                [self.userDictionary setValue:_lastNameTextField.text forKey:@"lastName"];
            }
            if ([[self.userDictionary valueForKey:@"birthday"] isKindOfClass:[NSNull class]]) {
                [self.userDictionary setValue:_birthdayTextField.text forKey:@"birthday"];
            }
            if ([[self.userDictionary valueForKey:@"gender"] isKindOfClass:[NSNull class]]) {
                [self.userDictionary setValue:_genderTextField.text forKey:@"gender"];
            }
            NSLog(@"%@", [self.userDictionary valueForKey:@"birthday"]);
            NSString *birthdayValue = [NSDateFormatter localizedStringFromDate:[NSDate dateSinceJavaEpochTime:[self.userDictionary valueForKey:@"birthday"]] dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
            NSString *genderValue = [[self.userDictionary valueForKey:@"gender"] isEqualToNumber:@0] ? @"Female" : @"Male";
            
            if((![[self.userDictionary valueForKey:@"firstName"] isEqualToString:(_firstNameTextField.text)]) ||
               (![[self.userDictionary valueForKey:@"lastName"] isEqualToString:(_lastNameTextField.text)]) ||
               (![genderValue isEqualToString:(_genderTextField.text)]) ||
               (![birthdayValue isEqualToString:(_birthdayTextField.text)]) ||
               (_passwordTextField.text))
            {
                int gender = [_genderTextField.text isEqualToString:@"Male"] ? 1 : 0;
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MMM dd, yyyy"];
                [dateFormatter setDateStyle:NSDateFormatterLongStyle];
                [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
                
                NSDate *birthdayDate = [[NSDate alloc] init];
                birthdayDate = [dateFormatter dateFromString:_birthdayTextField.text];
                NSTimeInterval bdayUnixTime = birthdayDate.timeIntervalSince1970;
                
                [self.userDictionary setValue:_firstNameTextField.text forKey:@"firstName"];
                [self.userDictionary setValue:_lastNameTextField.text forKey:@"lastName"];
                [self.userDictionary setValue:[NSNumber numberWithDouble:bdayUnixTime] forKey:@"birthday"];
                [self.userDictionary setValue:[NSNumber numberWithInt:gender] forKey:@"gender"];
                
                
                if([[NSUserDefaults standardUserDefaults] valueForKey:@"oauthUser"])
                {
                    [self.userDictionary setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"apnsToken"] forKey:@"deviceId"];
                    [self.userDictionary setValue:@"true" forKey:@"useOAuth"];
                    [self.userDictionary setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"oauthToken"] forKey:@"oauthToken"];
                    [self.userDictionary setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"oauthProvider"] forKey:@"provider"];
                    [self.userDictionary setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] forKey:@"providerUserName"];
                    
                    [MMAPI oauthSignIn:self.userDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [SVProgressHUD showSuccessWithStatus:@"Updated User Information"];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Operation: %@", operation);
                        NSLog(@"Error: %@", error);
                    }];
                    
                    [super viewWillDisappear:animated];
                }
                else
                {
                    if(_passwordTextField.text && _confirmPasswordTextField.text)
                    {
                        if([_passwordTextField.text isEqualToString:_confirmPasswordTextField.text])
                        {
                            [self.userDictionary setValue:_passwordTextField.text forKey:@"password"];
                            
                            [MMAPI updateUserOnSuccess:self.userDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                [SVProgressHUD showSuccessWithStatus:@"Updated User Information"];
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                NSLog(@"Operation: %@", operation);
                                NSLog(@"Error: %@", error);
                            }];
                            
                            [super viewWillDisappear:animated];
                        }
                        else
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Mismatch" message:@"The passwords you have entered do not match. Please re-enter your password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [alert show];
                        }
                    }
                    else
                    {
                        [self.userDictionary setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"] forKey:@"password"];
                        
                        [MMAPI updateUserOnSuccess:self.userDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [SVProgressHUD showSuccessWithStatus:@"Updated User Information"];
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"Operation: %@", operation);
                            NSLog(@"Error: %@", error);
                        }];
                        
                        [super viewWillDisappear:animated];
                    }
                    
                }
                
            }

        }
    }
}

@end
