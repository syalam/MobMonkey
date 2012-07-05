//
//  FilterViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UIPickerView *pickerView;
    
    NSString *rangeSelection;
    NSMutableArray *pickerArray;
}

- (IBAction)segmentedControlSelected:(id)sender;

@end
