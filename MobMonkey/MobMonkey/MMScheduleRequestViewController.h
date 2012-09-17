//
//  MMScheduleRequestViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMScheduleDelegate

- (void)selectedScheduleDate:(NSDate*)scheduleDate;

@end

@interface MMScheduleRequestViewController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIButton *scheduleItButton;
@property (nonatomic, assign) id<MMScheduleDelegate>delegate;


- (IBAction)scheduleItButtonTapped:(id)sender;

@end
