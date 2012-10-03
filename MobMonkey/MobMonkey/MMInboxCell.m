//
//  MMInboxCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/1/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMInboxCell.h"

@implementation MMInboxCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _locationNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 300, 20)];
        _requestTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 35, 300, 20)];
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 55, 300, 20)];
        _timestampLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 75, 300, 15)];
        
        [_locationNameLabel setBackgroundColor:[UIColor clearColor]];
        [_requestTypeLabel setBackgroundColor:[UIColor clearColor]];
        [_messageLabel setBackgroundColor:[UIColor clearColor]];
        [_timestampLabel setBackgroundColor:[UIColor clearColor]];
        
        UIColor *textColor = [UIColor whiteColor];
        
        [_locationNameLabel setTextColor:textColor];
        [_requestTypeLabel setTextColor:textColor];
        [_messageLabel setTextColor:textColor];
        [_timestampLabel setTextColor:textColor];
        
        [_messageLabel setNumberOfLines:0];
        [_messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        [self.contentView addSubview:_locationNameLabel];
        [self.contentView addSubview:_requestTypeLabel];
        [self.contentView addSubview:_messageLabel];
        [self.contentView addSubview:_timestampLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
