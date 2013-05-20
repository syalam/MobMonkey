//
//  MMLocationFilterTableViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 5/17/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMTextFieldCell.h"

@interface MMLocationFilterTableViewController : UITableViewController <UITextFieldDelegate> {
    NSString *cityOrStateString;
    NSString *zipString;
}

@property (copy, nonatomic) void (^searchAction)(NSString *cityOrZip);
@property (nonatomic, strong) NSString *cityOrStateString;
@property (nonatomic, strong) NSString *zipString;

@end
