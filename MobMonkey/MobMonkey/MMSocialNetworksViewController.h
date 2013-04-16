//
//  MMSocialNetworksViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/11/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMSocialNetworksCell.h"
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MMSocialNetworksViewController : UIViewController <MMSocialNetworksCellDelegate, UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *contentList;


@end
