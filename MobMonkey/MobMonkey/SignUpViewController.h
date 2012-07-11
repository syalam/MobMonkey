//
//  SignUpViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UITableViewController {
    IBOutlet UIButton *signUpButton;
    IBOutlet UIButton *signInButton;
    
    UITextField *firstNameTextField;
    UITextField *lastNameTextField;
    UITextField *emailTextField;
    UITextField *passwordTextField;
    UITextField *confirmPasswordTextField;
}

- (IBAction)signUpButtonClicked:(id)sender;
- (IBAction)signInButtonClicked:(id)sender;

- (void)showAlertView:(NSString*)message;

@property (nonatomic, retain)NSMutableArray *contentList;

@end
