//
//  LoginViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface LoginViewController : UITableViewController {
    UITextField *emailTextField;
    UITextField *passwordTextField;
    
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *signUpButton;
}

- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)signUpButtonClicked:(id)sender;


@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) HomeViewController *homeScreen;

@end
