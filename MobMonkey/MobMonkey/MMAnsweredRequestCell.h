//
//  MMAnsweredRequestCell.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCImageView.h"

@protocol MMAnsweredRequestCellDelegate

- (void)expandImageButtonTapped:(id)sender;
- (void)actionButtonTapped:(id)sender;
- (void)acceptButtonTapped:(id)sender;
- (void)rejectButtonTapped:(id)sender;
- (void)imageTapped:(id)sender;

@end

@interface MMAnsweredRequestCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic, retain) TCImageView *responseImageView;
@property (nonatomic, retain) UIButton *expandImageButton;
@property (nonatomic, retain) UIImageView *overlayImageView;
@property (nonatomic, retain) UIButton *actionButton;
@property (nonatomic, retain) UIButton *acceptButton;
@property (nonatomic, retain) UIButton *rejectButton;
@property (nonatomic, assign) id <MMAnsweredRequestCellDelegate> delegate;


@end