//
//  MMNotificationSettingsViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/6/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMNotificationSettingsDelegate

- (void)selectedSetting:(id)selectedNotificationSetting;

@end

@interface MMNotificationSettingsViewController : UIViewController 


@property (nonatomic, weak) IBOutlet UIImageView *screenBackground;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) NSString *selectedItem;
@property (nonatomic, retain) id<MMNotificationSettingsDelegate> delegate;

@end
