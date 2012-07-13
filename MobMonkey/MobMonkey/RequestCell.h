//
//  RequestCell.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RequestCellDelegate

- (void)respondButtonTapped:(id)sender event:(id)event;
- (void)ignoreButtonTapped:(id)sender event:(id)event;

@end

@interface RequestCell : UITableViewCell

@property (nonatomic, retain) UILabel *notificationTextLabel;
@property (nonatomic, retain) UIButton *respondButton;
@property (nonatomic, retain) UIButton *ignoreButton;
@property (nonatomic, assign) id<RequestCellDelegate> delegate;

@end
