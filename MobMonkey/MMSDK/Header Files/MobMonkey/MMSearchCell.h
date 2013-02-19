//
//  MMSearchCell.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/18/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMSearchCellDelegate

@required
-(void)mmSearchCellViewLiveFeedButtonTapped:(id)sender;
-(void)mmSearchCellViewUploadedPhotoButtonTapped:(id)sender;
-(void)mmSearchCellViewUploadedVideoButtonTapped:(id)sender;
-(void)mmSearchCellUploadPhotoButtonTapped:(id)sender;
-(void)mmSearchCellUploadVideoButtonTapped:(id)sender;

@end

@interface MMSearchCell : UITableViewCell

@property (nonatomic, retain) UIImageView *mmSearchCellBackgroundImageView;
@property (nonatomic, retain) UIImageView *mmSearchCellMMEnabledIndicator;
@property (nonatomic, retain) UILabel *mmSearchCellLocationNameLabel;
@property (nonatomic, retain) UILabel *mmSearchCellAddressLabel;
@property (nonatomic, retain) UILabel *mmSearchCellDistanceLabel;
@property (nonatomic, retain) UIView *mmSearchCellButtonView;
@property (nonatomic, retain) UIButton *mmSearchCellViewUploadedVideoButton;
@property (nonatomic, retain) UIButton *mmSearchCellViewUploadedPhotoButton;
@property (nonatomic, retain) UIButton *mmSearchCellViewLiveFeedButton;
@property (nonatomic, retain) UIButton *mmSearchCellUploadPhotoButton;
@property (nonatomic, retain) UIButton *mmSearchCellUploadVideoButton;
@property (nonatomic, assign) id<MMSearchCellDelegate>delegate;

@end
