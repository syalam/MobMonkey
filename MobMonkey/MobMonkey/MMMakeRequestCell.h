//
//  MMMakeRequestCell.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/11/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMMakeRequestCellDelegate

- (void)mmRequestPhotoVideoSegmentedControlTapped:(id)sender;

- (void)mmRequestStayActiveSegmentedControlTapped:(id)sender;

- (void)mmRequestScheduleSegmentedControlTapped:(id)sender;

- (void)mmRequestClearTextButtonTapped:(id)sender;

- (void)textViewDidChange:(UITextView *)textView;

- (void)textViewDidBeginEditing:(UITextView *)textView;

- (void)textViewDidEndEditing:(UITextView *)textView;

@end

@interface MMMakeRequestCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic, retain) UISegmentedControl *mmRequestPhotoVideoSegmentedControl;
@property (nonatomic, retain) UILabel *mmRequestTextLabel;
@property (nonatomic, retain) UITextView *mmRequestMessageTextView;
@property (nonatomic, retain) UISegmentedControl *mmRequestStayActiveSegmentedControl;
@property (nonatomic, retain) UISegmentedControl *mmRequestScheduleSegmentedControl;
@property (nonatomic, retain) UIButton *mmRequestClearTextButton;
@property (nonatomic, retain) id<MMMakeRequestCellDelegate> delegate;

@end
