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
#import "MMAPI.h"

@interface MMRequestViewController : UIViewController <UIGestureRecognizerDelegate, MMPresetMessageDelegate, UITableViewDataSource, UITableViewDelegate, MMMakeRequestCellDelegate, MMAPIDelegate> {
    UITapGestureRecognizer *dismissKeyboard;
    BOOL _textEntered;
    
    int photoVideoSegmentedControlSelection;
    int stayActiveSegmentedControlSelection;
    int scheduleItSegmentedControlSelection;
    
    NSString *messageText;
    NSNumber *selectedDuration;
    NSDate *selectedScheduleDate;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *sendRequestButton;

- (IBAction)sendRequestButtonTapped:(id)sender;

@end
