//
//  MMMakeRequestCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/11/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMMakeRequestCell.h"

@implementation MMMakeRequestCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization cell subviews
        _mmRequestPhotoVideoSegmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Photo", @"Video", nil]];
        _mmRequestMessageTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, 0, 240, 82)];
        _mmRequestClearTextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_mmRequestClearTextButton setFrame:CGRectMake(200, 50, 26, 24)];
        _mmRequestStayActiveSegmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"15m", @"30m", @"1hr", @"3hr", nil]];
        _mmRequestScheduleSegmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Request Now", @"Schedule", nil]];
        
        //set styles for subview segmented controls
        _mmRequestPhotoVideoSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBordered;
        _mmRequestStayActiveSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        _mmRequestScheduleSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBordered;
        
        //add selectors to segmented controls and buttons
        [_mmRequestPhotoVideoSegmentedControl addTarget:self action:@selector(mmRequestPhotoVideoSegmentedControlTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_mmRequestStayActiveSegmentedControl addTarget:self action:@selector(mmRequestStayActiveSegmentedControlTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_mmRequestScheduleSegmentedControl addTarget:self action:@selector(mmRequestScheduleSegmentedControlTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_mmRequestClearTextButton addTarget:self action:@selector(mmRequestClearTextButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //add items to the cell's content view
        [self.contentView addSubview:_mmRequestPhotoVideoSegmentedControl];
        [self.contentView addSubview:_mmRequestMessageTextView];
        [self.contentView addSubview:_mmRequestClearTextButton];
        [self.contentView addSubview:_mmRequestStayActiveSegmentedControl];
        [self.contentView addSubview:_mmRequestScheduleSegmentedControl];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IBAction Methods
- (void)mmRequestPhotoVideoSegmentedControlTapped:(id)sender {
    [_delegate mmRequestPhotoVideoSegmentedControlTapped:sender];
}

- (void)mmRequestStayActiveSegmentedControlTapped:(id)sender {
    [_delegate mmRequestStayActiveSegmentedControlTapped:sender];
}

- (void)mmRequestScheduleSegmentedControlTapped:(id)sender {
    [_delegate mmRequestScheduleSegmentedControlTapped:sender];
}

- (void)mmRequestClearTextButtonTapped:(id)sender {
    [_delegate mmRequestClearTextButtonTapped:sender];
}



@end
