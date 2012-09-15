//
//  MMPresetMessagesViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/2/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMakeRequestCell.h"

@protocol MMPresetMessageDelegate

- (void)presetMessageSelected:(id)message;

@end

@interface MMPresetMessagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MMMakeRequestCellDelegate, UIGestureRecognizerDelegate> {
    UITapGestureRecognizer *dismissKeyboard;
}

@property (nonatomic, retain) IBOutlet UIImageView *screenBackground;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) id<MMPresetMessageDelegate> delegate;

@end
