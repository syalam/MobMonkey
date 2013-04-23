//
//  MMSocialNetworksCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/11/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMSocialNetworksCell.h"

@implementation MMSocialNetworksCell

@synthesize cellType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _mmSocialNetworkTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 9, 190, 25)];
        _mmSocialNetworkSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
        [_mmSocialNetworkSwitch addTarget:self action:@selector(mmSocialNetworksSwitchTapped:) forControlEvents:UIControlEventValueChanged];
        
        [_mmSocialNetworkTextLabel setBackgroundColor:[UIColor clearColor]];
        [_mmSocialNetworkTextLabel setFont:[UIFont boldSystemFontOfSize:17]];
        
        [self.contentView addSubview:_mmSocialNetworkTextLabel];
        self.accessoryView = _mmSocialNetworkSwitch;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Action Methods
- (void)mmSocialNetworksSwitchTapped:(UISwitch*)sender {
    if([self.delegate respondsToSelector:@selector(mmSocialNetworksSwitchTapped:)]){
        [_delegate mmSocialNetworksSwitchTapped:sender];

    }
        
    if([self.delegate respondsToSelector:@selector(socialNetworkCell:switchChanges:)]){
        [self.delegate socialNetworkCell:self switchChanges:sender];
    }
}

@end
