//
//  TwitterAccounts.h
//  fizzpoints
//
//  Created by Reyaad Sidique on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@protocol TwitterAccountsDelegate

- (void)showAccounts:(UIActionSheet*)accounts;

@end

@interface TwitterAccounts : NSObject {
    id delegateClass;
}

- (void)fetchData;

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) NSArray *accounts;
@property (strong, nonatomic) id<TwitterAccountsDelegate> delegate;

@end
