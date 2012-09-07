//
//  MMSignUpViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMSignUpViewController : UITableViewController <UIActionSheetDelegate, UITextFieldDelegate> {
    UIActionSheet *birthdayActionSheet;
    UIDatePicker *datePicker;
}

- (IBAction)signUpButtonClicked:(id)sender;
- (IBAction)signInButtonClicked:(id)sender;
- (IBAction)facebookButtonTapped:(id)sender;
- (IBAction)twitterButtonTapped:(id)sender;
- (IBAction)saveButtonTapped:(id)sender;

- (void)showAlertView:(NSString*)message;

@property (nonatomic, retain)NSMutableArray *contentList;
@property (nonatomic, retain)UITextField *firstNameTextField;
@property (nonatomic, retain)UITextField *lastNameTextField;
@property (nonatomic, retain)UITextField *emailTextField;
@property (nonatomic, retain)UITextField *passwordTextField;
@property (nonatomic, retain)UITextField *confirmPasswordTextField;
@property (nonatomic, retain)UITextField *birthdayTextField;
@property (nonatomic, retain)UITextField *genderTextField;
@property (nonatomic, retain)UITextField *phoneNumberTextField;
@property (nonatomic, retain)IBOutlet UIButton *saveButton;
@property (nonatomic, retain)IBOutlet UIButton *signUpButton;
@property (nonatomic, retain)IBOutlet UIButton *signInButton;
@property (nonatomic, retain)IBOutlet UIButton *facebookButton;
@property (nonatomic, retain)IBOutlet UIButton *twitterButton;

@end
