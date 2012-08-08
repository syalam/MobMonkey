//
//  HomeViewController.h
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "RequestsViewController.h"
#import <FactualSDK/FactualAPI.h>
#import <FactualSDK/FactualQuery.h>

@interface HomeViewController : UITableViewController <FactualAPIDelegate> {
    IBOutlet UIView *headerView;
    
    UIImageView *notificationsImageView;
    UILabel *notificationsCountLabel;
    
    FactualAPIRequest* _activeRequest;
    FactualQueryResult* _queryResult;
    CLLocation* _queryLocation;
    
    RequestsViewController *notificationScreen;
}

@property (nonatomic, retain)NSString *screen;
@property (nonatomic, retain)NSMutableArray *pendingRequestsArray;
@property (nonatomic, retain)NSMutableArray *contentList;
@property (nonatomic,retain)  FactualQueryResult* queryResult;

- (void)notificationsButtonTapped:(id)sender;
- (void)setNavButtons;
- (void)checkForNotifications;
- (void)doQuery:(id)sender;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
