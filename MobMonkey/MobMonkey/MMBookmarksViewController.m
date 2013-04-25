//
//  MMBookmarksViewController.m
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/11/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMBookmarksViewController.h"
#import "MMLocationsViewController.h"
#import "MMAPI.h"
#import "MMClientSDK.h"

@interface MMBookmarksViewController ()

@property (strong, nonatomic) MMLocationsViewController *locationsViewController;

@end

@implementation MMBookmarksViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [SVProgressHUD dismiss];
    [self getBookmarks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getBookmarks
{
    [MMAPI getBookmarkLocationInformationOnSuccess:^(AFHTTPRequestOperation *operation, NSArray *locationInformations) {
       
        self.locationsInformationCollection = locationInformations.mutableCopy;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.responseData) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            if ([[response valueForKey:@"status"] isEqualToString:@"Unauthorized"]) {
                //[[MMClientSDK sharedSDK] signInScreen:self];
            }
        }
    }];
    
    /*[MMAPI getBookmarksOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", [responseObject description]);
        
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.responseData) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            if ([[response valueForKey:@"status"] isEqualToString:@"Unauthorized"]) {
                //[[MMClientSDK sharedSDK] signInScreen:self];
            }
        }
        
    }];*/
}

@end
