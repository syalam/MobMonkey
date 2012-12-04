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
    [MMAPI getBookmarksOnSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", [responseObject description]);
        
        //  Monkey hack until API is fixed
        NSMutableArray *locations = [NSMutableArray array];
        NSMutableDictionary *mutableLocation;
        for (NSDictionary *location in responseObject) {
            mutableLocation = [location mutableCopy];
            [mutableLocation setValue:[NSNumber numberWithBool:YES] forKey:@"bookmark"];
            [locations addObject:mutableLocation];
        }
        self.locations = locations;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        if ([[response valueForKey:@"status"] isEqualToString:@"Unauthorized"]) {
            [[MMClientSDK sharedSDK] signInScreen:self];
        }
    }];
}

@end
