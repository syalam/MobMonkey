//
//  MMRequestScheduleViewController.h
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/19/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MMRequestScheduleDelegate

- (void)RequestScheduleSetWithDictionary:(NSDictionary*)requestScheduleParams;

@end

@interface MMRequestScheduleViewController : UITableViewController {
    IBOutlet UISegmentedControl *frequencySelector;
    IBOutlet UISwitch *recurringSwitch;
    int frequency;
}

- (IBAction)frequencySelectorTapped:(id)sender;
- (IBAction)recurringSwitchTapped:(id)sender;

@property (weak, nonatomic) NSMutableDictionary *requestInfo;
@property (nonatomic, assign)id<MMRequestScheduleDelegate> delegate;

@end
