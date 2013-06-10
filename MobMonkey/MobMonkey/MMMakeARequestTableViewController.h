//
//  MMMakeARequestTableViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 6/6/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMLocationInformation.h"


@interface MMMakeARequestTableViewController : UITableViewController <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic, strong) MMLocationInformation *locationInformation;
@end
