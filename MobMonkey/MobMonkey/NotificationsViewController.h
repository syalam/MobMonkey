//
//  NotificationsViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>  {
    IBOutlet UIPickerView *picker;
    IBOutlet UISwitch *notificationSwitch;
    
    NSMutableArray *notificationNumberArray;
    NSMutableArray *notificationUnitArray;
}

- (IBAction)notificationSwitchSelected:(id)sender;

@end
