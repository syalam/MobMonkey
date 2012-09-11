//
//  MMRequestViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/2/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPresetMessagesViewController.h"
#import "MMMakeRequestCell.h"


@interface MMRequestViewController : UIViewController <UITextViewDelegate, UIGestureRecognizerDelegate, MMPresetMessageDelegate, UITableViewDataSource, UITableViewDelegate, MMMakeRequestCellDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction)attachMessageButtonTapped:(id)sender;
- (IBAction)clearTextButtonTapped:(id)sender;
- (IBAction)scheduleRequestButtonTapped:(id)sender;

@end
