//
//  RequestCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestCell.h"

@implementation RequestCell
@synthesize notificationTextLabel = _notificationTextLabel;
@synthesize respondButton = _respondButton;
@synthesize ignoreButton = _ignoreButton;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _notificationTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 200, 30)];
        
        _respondButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_respondButton setFrame:CGRectMake(20, 40, 80, 30)];
        [_respondButton setTitle:@"Respond" forState:UIControlStateNormal];
        [_respondButton addTarget:self action:@selector(respondButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _ignoreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_ignoreButton setFrame:CGRectMake(120, 40, 80, 30)];
        [_ignoreButton setTitle:@"Ignore" forState:UIControlStateNormal];
        [_ignoreButton addTarget:self action:@selector(ignoreButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_notificationTextLabel];
        [self.contentView addSubview:_respondButton];
        [self.contentView addSubview:_ignoreButton];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)respondButtonTapped:(id)sender {
    [_delegate respondButtonTapped:sender];
}

- (void)ignoreButtonTapped:(id)sender {
    [_delegate ignoreButtonTapped:sender];
}

@end
