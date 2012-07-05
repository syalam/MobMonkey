//
//  SearchViewController.h
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCell.h"

@interface SearchViewController : UITableViewController <SearchCellDelegate>

@property (nonatomic, retain)NSMutableArray *contentList;

@end
