//
//  MMScheduleRequestViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMScheduleRequestDelegate

- (void)selectedScheduleDate:(NSDate*)scheduleDate recurring:(BOOL)recurring;

@end

@interface MMScheduleRequestViewController : UIViewController {
    
}

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) IBOutlet UIButton *scheduleItButton;
@property (nonatomic, weak) IBOutlet UISwitch *recurringSwitch;
@property (nonatomic, assign) id<MMScheduleRequestDelegate> delegate;


- (IBAction)scheduleItButtonTapped:(id)sender;

@end
