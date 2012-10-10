//
//  MMSignUpViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "MMAPI.h"
#import "TwitterAccounts.h"

@interface MMSignUpViewController : UITableViewController <UIActionSheetDelegate, UITextFieldDelegate, TwitterAccountsDelegate, MMAPIDelegate> {
}

- (IBAction)signUpButtonTapped:(id)sender;
- (IBAction)signInButtonClicked:(id)sender;
- (IBAction)facebookButtonTapped:(id)sender;
- (IBAction)twitterButtonTapped:(id)sender;

@property (nonatomic, weak) IBOutlet UIButton *signUpButton;
@property (nonatomic, weak) IBOutlet UIButton *facebookButton;
@property (nonatomic, weak) IBOutlet UIButton *twitterButton;

@end
