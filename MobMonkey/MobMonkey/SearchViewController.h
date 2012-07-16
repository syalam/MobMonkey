//
//  SearchViewController.h
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCell.h"
#import <FactualSDK/FactualAPI.h>
#import "FilterViewController.h";

@interface SearchViewController : UITableViewController <SearchCellDelegate, UITextFieldDelegate, FactualAPIDelegate, FilterViewDelegate> {
    IBOutlet UIView *headerView;
    IBOutlet UITextField *categoryTextField;
    IBOutlet UITextField *nearTextField;
    
    UIBarButtonItem *filterButton;
    UIBarButtonItem *mapButton;
    UIBarButtonItem *cancelButton;
    
    FactualAPIRequest* _activeRequest;
    FactualQueryResult* _queryResult;
    NSUserDefaults* prefs;
}

@property (nonatomic, retain)NSMutableArray *contentList;

@end
