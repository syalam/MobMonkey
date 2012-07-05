//
//  MapViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController <UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    IBOutlet UIButton *radiusButton;
    IBOutlet UIButton *addLocationButton;
    
    UIActionSheet *radiusActionSheet;
    UIPickerView *radiusPicker;
    
    NSMutableArray *radiusPickerItemsArray;
}

- (IBAction)radiusButtonClicked:(id)sender;
- (IBAction)addLocationButtonClicked:(id)sender;

@end
