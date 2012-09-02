//
//  MMSearchViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/2/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMResultCell.h"

@interface MMSearchViewController : UITableViewController <MMResultCellDelegate> {
    NSMutableDictionary* _cellToggleOnState;
}


@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) IBOutlet UIImageView *searchBackgroundImageView;
@property (nonatomic, retain) IBOutlet UIImageView *searchTextFieldBackgroundImageView;
@property (nonatomic, retain) IBOutlet UITextField *searchTextField;

@end
