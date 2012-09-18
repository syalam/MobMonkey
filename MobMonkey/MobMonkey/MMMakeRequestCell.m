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
        // Initialize cell subviews
        _mmRequestTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 2, 270, 25)];
        _mmRequestPhotoVideoSegmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Photo", @"Video", nil]];
        _mmRequestPhotoVideoSegmentedControl.selectedSegmentIndex = 0;
        _mmRequestMessageTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 240, 82)];
        _mmRequestClearTextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _mmRequestStayActiveSegmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"15m", @"30m", @"1hr", @"3hr", nil]];
        _mmRequestStayActiveSegmentedControl.selectedSegmentIndex = 1;
        _mmRequestScheduleSegmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Request Now", @"Schedule", nil]];
        _mmRequestScheduleSegmentedControl.selectedSegmentIndex = 0;
        _mmClearRequestScheduleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        //set frames for items which did not have frames set on initialization
        [_mmRequestPhotoVideoSegmentedControl setFrame:CGRectMake(300/2 - _mmRequestPhotoVideoSegmentedControl.frame.size.width/2, 5, _mmRequestPhotoVideoSegmentedControl.frame.size.width, _mmRequestPhotoVideoSegmentedControl.frame.size.height)];
        [_mmRequestMessageTextView setFrame:CGRectMake(300/2 - _mmRequestMessageTextView.frame.size.width/2, 5, _mmRequestMessageTextView.frame.size.width, _mmRequestMessageTextView.frame.size.height)];
        [_mmRequestClearTextButton setFrame:CGRectMake(230, 57, 26, 24)];
        [_mmRequestStayActiveSegmentedControl setFrame:CGRectMake(300/2 - 215/2, 30, 215, 35)];
        [_mmRequestScheduleSegmentedControl setFrame:CGRectMake(300/2 - _mmRequestScheduleSegmentedControl.frame.size.width/2, 5, _mmRequestScheduleSegmentedControl.frame.size.width, _mmRequestScheduleSegmentedControl.frame.size.height)];
        [_mmClearRequestScheduleButton setFrame:CGRectMake(255, 5, 30, 30)];
        
        //Add label to clear text button and set delegate
        [_mmRequestClearTextButton setTitle:@"x" forState:UIControlStateNormal];
        [_mmClearRequestScheduleButton setTitle:@"x" forState:UIControlStateNormal];
        
        _mmRequestMessageTextView.delegate = self;
        
        //set styles for segmented controls
        _mmRequestPhotoVideoSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBordered;
        _mmRequestStayActiveSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        _mmRequestScheduleSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBordered;
        
        //add selectors to segmented controls and buttons
        [_mmRequestPhotoVideoSegmentedControl addTarget:self action:@selector(mmRequestPhotoVideoSegmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
        [_mmRequestStayActiveSegmentedControl addTarget:self action:@selector(mmRequestStayActiveSegmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
        [_mmRequestScheduleSegmentedControl addTarget:self action:@selector(mmRequestScheduleSegmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
        [_mmRequestClearTextButton addTarget:self action:@selector(mmRequestClearTextButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_mmClearRequestScheduleButton addTarget:self action:@selector(mmClearRequestScheduleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        //Configure label
        [_mmRequestTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13]];
        [_mmRequestTextLabel setBackgroundColor:[UIColor clearColor]];
        
        //hide all elements
        [_mmRequestTextLabel setHidden:YES];
        [_mmRequestPhotoVideoSegmentedControl setHidden:YES];
        [_mmRequestMessageTextView setHidden:YES];
        [_mmRequestClearTextButton setHidden:YES];
        [_mmRequestStayActiveSegmentedControl setHidden:YES];
        [_mmRequestScheduleSegmentedControl setHidden:YES];
        [_mmClearRequestScheduleButton setHidden:YES];
        
        //add items to the cell's content view
        [self.contentView addSubview:_mmRequestTextLabel];
        [self.contentView addSubview:_mmRequestPhotoVideoSegmentedControl];
        [self.contentView addSubview:_mmRequestMessageTextView];
        [self.contentView addSubview:_mmRequestClearTextButton];
        [self.contentView addSubview:_mmRequestStayActiveSegmentedControl];
        [self.contentView addSubview:_mmRequestScheduleSegmentedControl];
        [self.contentView addSubview:_mmClearRequestScheduleButton];
        
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

- (void)mmClearRequestScheduleButtonTapped:(id)sender {
    [_delegate mmClearRequestScheduleButtonTapped:sender];
}

#pragma mark - UITextView delegate methods
- (void)textViewDidChange:(UITextView *)textView {
    [_delegate textViewDidChange:textView];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [_delegate textViewDidBeginEditing:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [_delegate textViewDidEndEditing:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString* newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    else if([newText length] > 100)
    {
        return NO; // can't enter more text
    }
    else
        return YES; // let the textView know that it should handle the inserted text
}


@end
