//
//  AddLocationViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddLocationViewController : UITableViewController {
    UITextField *nameTextField;
    UITextField *locationTextField;
}

@property (nonatomic, retain)NSMutableArray *contentList;

@end
