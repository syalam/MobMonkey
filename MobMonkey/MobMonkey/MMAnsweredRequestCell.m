//
//  MMAnsweredRequestCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMAnsweredRequestCell.h"

@implementation MMAnsweredRequestCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _responseImageView = [[TCImageView alloc]initWithFrame:CGRectMake(5, 5, 310, 310)];
        
        [_responseImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_responseImageView setClipsToBounds:YES];
        [_responseImageView setCaching:YES];
        
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _acceptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _rejectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [_actionButton setFrame:CGRectMake(270, 270, 27, 20)];
        [_acceptButton setFrame:CGRectMake(15, 320, 140, 30)];
        [_rejectButton setFrame:CGRectMake(170, 320, 140, 30)];
        
        [_actionButton addTarget:self action:@selector(actionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_acceptButton addTarget:self action:@selector(acceptButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_rejectButton addTarget:self action:@selector(rejectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [_actionButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [_acceptButton setTitle:@"Accept" forState:UIControlStateNormal];
        [_rejectButton setTitle:@"Reject" forState:UIControlStateNormal];
        
        [self.contentView addSubview:_responseImageView];
        [self.contentView addSubview:_actionButton];
        [self.contentView addSubview:_acceptButton];
        [self.contentView addSubview:_rejectButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)actionButtonTapped:(id)sender {
    [_delegate actionButtonTapped:sender];
}

- (void)acceptButtonTapped:(id)sender {
    [_delegate acceptButtonTapped:sender];
}

- (void)rejectButtonTapped:(id)sender {
    [_delegate rejectButtonTapped:sender];
}

@end
