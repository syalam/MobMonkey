//
//  RequestsViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "RequestCell.h"

@interface RequestsViewController : UITableViewController <RequestCellDelegate> {
    NSMutableArray *indexPathArray;
    
    int currentIndex;
    NSIndexPath *responseIndexPath;
    
}

@property (nonatomic, retain) NSMutableArray *contentList;


- (void)responseComplete:(PFObject *)requestObject;

@end
