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

@interface HomeViewController : UITableViewController {
    IBOutlet UIView *headerView;
    
    RequestsViewController *notificationScreen;
}

@property (nonatomic, retain)NSString *screen;
@property (nonatomic, retain)NSMutableArray *pendingRequestsArray;

- (void)setNavButtons;
- (void)checkForNotifications;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
