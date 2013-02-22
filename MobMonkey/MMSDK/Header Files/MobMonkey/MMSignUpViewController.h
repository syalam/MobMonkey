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

@interface MMSignUpViewController : UITableViewController <UIActionSheetDelegate, UITextFieldDelegate> {
    int actionSheetCall;
    IBOutlet UIButton *termsOfUseAcceptanceButton;
    IBOutlet UIButton *termsOfUseButton;
    BOOL termsOfUseAccepted;
}

- (IBAction)signUpButtonTapped:(id)sender;
- (IBAction)facebookButtonTapped:(id)sender;
- (IBAction)twitterButtonTapped:(id)sender;
- (IBAction)termsOfUseAcceptanceButtonTapped:(id)sender;
- (IBAction)termsOfUseButtonTapped:(id)sender;

@property (nonatomic, weak) IBOutlet UIButton *signUpButton;
@property (nonatomic, weak) IBOutlet UIButton *facebookButton;
@property (nonatomic, weak) IBOutlet UIButton *twitterButton;
@property (nonatomic, retain) NSArray *twitterAccounts;
@property (nonatomic, weak) NSDictionary *themeOptionsDictionary;
@property (nonatomic) BOOL twitterSignIn;

@end
