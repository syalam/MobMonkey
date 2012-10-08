//
//  MMSearchCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/18/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMSearchCell.h"

@implementation MMSearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Inititialize main elements
        CGFloat labelXSize = 280;
        
        _mmSearchCellBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 140)];
        _mmSearchCellMMEnabledIndicator = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 10, 10)];
        _mmSearchCellLocationNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, labelXSize, 30)];
        _mmSearchCellAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, labelXSize, 30)];
        _mmSearchCellDistanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, labelXSize, 30)];
        _mmSearchCellButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 85, 300, 50)];
        
        //initialize buttonview subviews
        _mmSearchCellViewUploadedVideoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _mmSearchCellViewUploadedPhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _mmSearchCellViewLiveFeedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _mmSearchCellUploadPhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _mmSearchCellUploadVideoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        
        //set cell background image
        _mmSearchCellBackgroundImageView.image = [UIImage imageNamed:@"roundedRectLarge"];
        _mmSearchCellBackgroundImageView.clipsToBounds = YES;
        
        //set button frames
        CGFloat buttonXCoordinate = 5;
        CGFloat buttonYCoordinate = 0;
        CGFloat buttonXSize = 50;
        CGFloat buttonYSize = 50;
        
        [_mmSearchCellViewUploadedVideoButton setFrame:CGRectMake(buttonXCoordinate, buttonYCoordinate, buttonXSize, buttonYSize)];
        //get x coordinate for next button and set frame
        buttonXCoordinate = [self determineNextButtonXCooridanate:buttonXCoordinate prevButtonXSize:buttonXSize];
        [_mmSearchCellViewUploadedPhotoButton setFrame:CGRectMake(buttonXCoordinate, buttonYCoordinate, buttonXSize, buttonYSize)];
        
        //get x coordinate for next button and set frame
        buttonXCoordinate = [self determineNextButtonXCooridanate:buttonXCoordinate prevButtonXSize:buttonXSize];
        [_mmSearchCellViewLiveFeedButton setFrame:CGRectMake(buttonXCoordinate, buttonYCoordinate, buttonXSize, buttonYSize)];
        
        //get x coordinate for next button and set frame
        buttonXCoordinate = [self determineNextButtonXCooridanate:buttonXCoordinate prevButtonXSize:buttonXSize];
        [_mmSearchCellUploadPhotoButton setFrame:CGRectMake(buttonXCoordinate, buttonYCoordinate, buttonXSize, buttonYSize)];
        
        //get x coordinate for next button and set frame
        buttonXCoordinate = [self determineNextButtonXCooridanate:buttonXCoordinate prevButtonXSize:buttonXSize];
        [_mmSearchCellUploadVideoButton setFrame:CGRectMake(buttonXCoordinate, buttonYCoordinate, buttonXSize, buttonYSize)];
        
        //set button titles
        [_mmSearchCellViewUploadedVideoButton setTitle:@"View Video" forState:UIControlStateNormal];
        [_mmSearchCellViewUploadedPhotoButton setTitle:@"View Photo" forState:UIControlStateNormal];
        [_mmSearchCellViewLiveFeedButton setTitle:@"Live Video" forState:UIControlStateNormal];
        [_mmSearchCellUploadPhotoButton setTitle:@"Upload Photo" forState:UIControlStateNormal];
        [_mmSearchCellUploadVideoButton setTitle:@"Upload Video" forState:UIControlStateNormal];
        
        //add buttons to button view
        [_mmSearchCellButtonView addSubview:_mmSearchCellViewUploadedVideoButton];
        [_mmSearchCellButtonView addSubview:_mmSearchCellViewUploadedPhotoButton];
        [_mmSearchCellButtonView addSubview:_mmSearchCellViewLiveFeedButton];
        [_mmSearchCellButtonView addSubview:_mmSearchCellUploadPhotoButton];
        [_mmSearchCellButtonView addSubview:_mmSearchCellUploadVideoButton];
        
        //Configure labels
        _mmSearchCellLocationNameLabel.backgroundColor = [UIColor clearColor];
        _mmSearchCellAddressLabel.backgroundColor = [UIColor clearColor];
        _mmSearchCellDistanceLabel.backgroundColor = [UIColor clearColor];
        
        _mmSearchCellLocationNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        _mmSearchCellAddressLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _mmSearchCellDistanceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        
        _mmSearchCellLocationNameLabel.textColor = [UIColor darkGrayColor];
        _mmSearchCellAddressLabel.textColor = [UIColor darkGrayColor];
        _mmSearchCellDistanceLabel.textColor = [UIColor darkGrayColor];
        
        //Add targets for button selectors
        [_mmSearchCellViewUploadedVideoButton addTarget:self action:@selector(mmSearchCellViewUploadedVideoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_mmSearchCellViewUploadedPhotoButton addTarget:self action:@selector(mmSearchCellViewUploadedPhotoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_mmSearchCellViewLiveFeedButton addTarget:self action:@selector(mmSearchCellViewLiveFeedButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_mmSearchCellUploadPhotoButton addTarget:self action:@selector(mmSearchCellUploadPhotoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_mmSearchCellUploadVideoButton addTarget:self action:@selector(mmSearchCellUploadVideoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        //add all elements to cell's content view as a subview
        [self.contentView addSubview:_mmSearchCellBackgroundImageView];
        [self.contentView addSubview:_mmSearchCellMMEnabledIndicator];
        [self.contentView addSubview:_mmSearchCellLocationNameLabel];
        [self.contentView addSubview:_mmSearchCellAddressLabel];
        [self.contentView addSubview:_mmSearchCellDistanceLabel];
        [self.contentView addSubview:_mmSearchCellButtonView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Cell Button Action Methods
-(void)mmSearchCellViewLiveFeedButtonTapped:(id)sender {
    [_delegate mmSearchCellViewLiveFeedButtonTapped:sender];
}
-(void)mmSearchCellViewUploadedPhotoButtonTapped:(id)sender {
    [_delegate mmSearchCellViewUploadedPhotoButtonTapped:sender];
}
-(void)mmSearchCellViewUploadedVideoButtonTapped:(id)sender {
    [_delegate mmSearchCellViewUploadedVideoButtonTapped:sender];
}
-(void)mmSearchCellUploadPhotoButtonTapped:(id)sender {
    [_delegate mmSearchCellUploadPhotoButtonTapped:sender];
}
-(void)mmSearchCellUploadVideoButtonTapped:(id)sender {
    [_delegate mmSearchCellUploadVideoButtonTapped:sender];
}

#pragma mark - helper methods
-(CGFloat)determineNextButtonXCooridanate:(CGFloat)prevButtonXCoordinate prevButtonXSize:(CGFloat)prevbuttonXSize {
    CGFloat nextButtonXCoordinate;
    nextButtonXCoordinate = prevButtonXCoordinate + prevbuttonXSize + 10;
    return nextButtonXCoordinate;
}

@end
