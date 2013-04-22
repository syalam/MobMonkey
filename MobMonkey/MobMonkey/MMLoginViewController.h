//
//  MMLoginViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MMAPI.h"

@interface MMLoginViewController : UITableViewController <MMAPIDelegate, UIActionSheetDelegate> {
    NSUserDefaults *prefs;
    int actionSheetCall;
}

- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)signUpButtonClicked:(id)sender;
- (IBAction)facebookButtonTapped:(id)sender;
- (IBAction)twitterButtonTapped:(id)sender;

@property (nonatomic, retain) NSArray* twitterAccounts;

@end