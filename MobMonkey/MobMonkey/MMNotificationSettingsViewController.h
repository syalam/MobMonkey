//
//  MMNotificationSettingsViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/6/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMNotificationSettingsViewController : UIViewController 


@property (nonatomic, retain)IBOutlet UIImageView *screenBackground;
@property (nonatomic, retain)IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain)NSMutableArray *contentList;
@property (nonatomic, retain)NSString *selectedItem;

@end
