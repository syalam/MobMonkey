//
//  MMLoginViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMLoginViewController : UITableViewController {
    UITextField *emailTextField;
    UITextField *passwordTextField;
    
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *signUpButton;
}

- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)signUpButtonClicked:(id)sender;

- (void)showAlertView:(NSString*)message;

@property (nonatomic, retain) NSMutableArray *contentList;

@end
