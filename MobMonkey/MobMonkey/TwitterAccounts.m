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
    [SVProgressHUD showWithStatus:@"Loading Twitter Accounts"];
    self.accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountTypeTwitter = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [_accountStore requestAccessToAccountsWithType:accountTypeTwitter options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            self.accounts = [self.accountStore accountsWithAccountType:accountTypeTwitter];
            if (!self.accounts) {
                [SVProgressHUD dismiss];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Twitter Account Detected" message:@"Please go into your device's settings menu to add your Twitter account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                [_delegate showAccounts:_accounts];
                /*UIActionSheet *twitterAccActionSheet = [[UIActionSheet alloc]initWithTitle:@"Twitter Accounts on This Device" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                for (NSInteger i = 0; i < _accounts.count; i++) {
                    ACAccount *account = [_accounts objectAtIndex:i];
                    [twitterAccActionSheet addButtonWithTitle:account.username];
                }
                twitterAccActionSheet.cancelButtonIndex = [twitterAccActionSheet addButtonWithTitle:@"Cancel"];
                
                twitterAccActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                twitterAccActionSheet.delegate = self;
                [_delegate showAccounts:twitterAccActionSheet];*/
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Please ensure that you've given us access to your Twitter account and that you have added Twitter accounts to your device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

#pragma mark - UIActionSheet delegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [_delegate twitterAccountsActionSheet:actionSheet clickedButtonAtIndex:buttonIndex accounts:_accounts];
}

@end
