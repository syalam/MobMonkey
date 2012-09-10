//
//  TwitterAccounts.m
//  fizzpoints
//
//  Created by Reyaad Sidique on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterAccounts.h"
#import "SVProgressHUD.h"

@implementation TwitterAccounts
@synthesize accounts = _accounts;
@synthesize accountStore = _accountStore;


- (void)fetchData {
    self.accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountTypeTwitter = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:accountTypeTwitter withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
            self.accounts = [self.accountStore accountsWithAccountType:accountTypeTwitter]; 
            if (!self.accounts) {
                [SVProgressHUD dismiss];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Twitter Account Detected" message:@"Please go into your device's settings menu to add your Twitter account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                [SVProgressHUD dismiss];
                [self showAccounts:_accounts];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"You have not granted us access to your Twitter account. Please update your settings in your iPhone's settings menu" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void)showAccounts:(NSArray*)accounts {
    UIActionSheet *twitterAccActionSheet = [[UIActionSheet alloc]initWithTitle:@"Twitter Accounts on This Device" delegate:delegateClass cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for (NSInteger i = 0; i < _accounts.count; i++) {
        ACAccount *account = [_accounts objectAtIndex:i];
        [twitterAccActionSheet addButtonWithTitle:account.username];
    }
    twitterAccActionSheet.cancelButtonIndex = [twitterAccActionSheet addButtonWithTitle:@"Cancel"];
    
    twitterAccActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    [_delegate showAccounts:twitterAccActionSheet];
}

@end
