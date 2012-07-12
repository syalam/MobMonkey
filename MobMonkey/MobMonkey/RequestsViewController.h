//
//  RequestsViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestsViewController : UITableViewController {
    
}

@property (nonatomic, retain) NSMutableArray *contentList;

- (void)getNotifications;

@end
