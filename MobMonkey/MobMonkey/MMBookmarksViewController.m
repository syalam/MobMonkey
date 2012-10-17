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
@property (strong, nonatomic) NSMutableArray *bookmarks;

@end

@implementation MMBookmarksViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
        self.locations = [responseObject mutableCopy];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Awe! Couldn't get bookmarks.");
    }];
}

@end
