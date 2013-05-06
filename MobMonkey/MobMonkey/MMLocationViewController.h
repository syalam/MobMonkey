//
//  MMLocationViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 5/6/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMLocationHeaderView.h"
#import "MMLocationInformation.h"
#import "MMLocationMediaViewController.h"

@interface MMLocationViewController : UITableViewController {
    MMLocationHeaderView *headerView;
}

@property (nonatomic, strong) MMLocationInformation *locationInformation;
@property (nonatomic, strong) NSArray *mediaArray;
@end
